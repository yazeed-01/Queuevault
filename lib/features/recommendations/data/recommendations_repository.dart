import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_env.dart';
import '../../../core/network/search_result.dart';
import '../../vault/data/models/item_type.dart';
import '../../vault/domain/vault_providers.dart';
import '../../../core/database/app_database.dart';

class RecommendationsRepository {
  Future<List<SearchResult>> fetchForItem(VaultItem item) async {
    final type = ItemTypeExt.fromString(item.itemType);
    return switch (type) {
      ItemType.movie => _tmdbRecs(item.externalId, 'movie'),
      ItemType.series => _tmdbRecs(item.externalId, 'tv'),
      ItemType.anime => _anilistRecs(item.anilistId),
      ItemType.game => _rawgRecs(item.externalId),
      ItemType.product => [],
    };
  }

  Future<List<SearchResult>> _tmdbRecs(String? id, String type) async {
    if (id == null) return [];
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = prefs.getString('tmdb_token')?.trim().isNotEmpty == true
          ? prefs.getString('tmdb_token')!
          : AppEnv.tmdbToken;
      if (key.isEmpty) return [];
      final dio = Dio(BaseOptions(baseUrl: ApiConstants.tmdbBase));
      final res = await dio.get('/$type/$id/recommendations',
          queryParameters: {'api_key': key, 'language': 'en-US'});
      final list = (res.data['results'] as List).take(12);
      return list.map((r) {
        final isMovie = type == 'movie';
        final poster = r['poster_path'];
        final backdrop = r['backdrop_path'];
        return SearchResult(
          id: r['id'].toString(),
          title: isMovie ? (r['title'] ?? '') : (r['name'] ?? ''),
          type: isMovie ? ItemType.movie : ItemType.series,
          posterUrl: poster != null ? '${ApiConstants.tmdbPosterW500}$poster' : null,
          backdropUrl: backdrop != null ? '${ApiConstants.tmdbBackdropW1280}$backdrop' : null,
          overview: r['overview'],
          extraData: {'tmdb_id': r['id'], 'vote_average': r['vote_average']},
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<SearchResult>> _anilistRecs(int? anilistId) async {
    if (anilistId == null) return [];
    try {
      final dio = Dio(BaseOptions(baseUrl: ApiConstants.anilistGraphql));
      const gql = r'''
        query ($id: Int) {
          Media(id: $id, type: ANIME) {
            recommendations(perPage: 12) {
              nodes {
                mediaRecommendation {
                  id
                  title { english romaji }
                  coverImage { large }
                  bannerImage
                  episodes
                  format
                  status
                  startDate { year }
                }
              }
            }
          }
        }
      ''';
      final res = await dio.post('', data: {'query': gql, 'variables': {'id': anilistId}});
      final nodes = res.data['data']['Media']['recommendations']['nodes'] as List;
      return nodes
          .map((n) => n['mediaRecommendation'])
          .where((m) => m != null)
          .map((r) {
        final title = r['title']['english'] ?? r['title']['romaji'] ?? 'Unknown';
        return SearchResult(
          id: r['id'].toString(),
          title: title,
          type: ItemType.anime,
          posterUrl: r['coverImage']['large'],
          backdropUrl: r['bannerImage'],
          year: r['startDate']?['year'],
          extraData: {
            'anilist_id': r['id'],
            'total_episodes': r['episodes'],
            'format': r['format'],
            'status': r['status'],
          },
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<SearchResult>> _rawgRecs(String? id) async {
    if (id == null) return [];
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = prefs.getString('rawg_key') ?? '';
      if (key.isEmpty) return [];
      final dio = Dio(BaseOptions(baseUrl: ApiConstants.rawgBase));
      final res = await dio.get('/games/$id/game-series', queryParameters: {'key': key, 'page_size': 12});
      final list = res.data['results'] as List;
      return list.map((r) => SearchResult(
            id: r['id'].toString(),
            title: r['name'] ?? '',
            type: ItemType.game,
            posterUrl: r['background_image'],
            extraData: {'rawg_id': r['id'], 'metacritic': r['metacritic']},
          )).toList();
    } catch (_) {
      return [];
    }
  }

  /// Genre-matched recommendations from the local vault
  Future<List<VaultItem>> fetchVaultRecs(VaultItem item, List<VaultItem> allItems) async {
    final genre = item.genre?.toLowerCase() ?? '';
    if (genre.isEmpty) return [];
    return allItems
        .where((v) =>
            v.id != item.id &&
            v.itemType == item.itemType &&
            (v.genre?.toLowerCase().contains(genre.split(',').first.trim()) ?? false))
        .take(6)
        .toList();
  }
}

final recommendationsRepositoryProvider =
    Provider<RecommendationsRepository>((ref) => RecommendationsRepository());

final recommendationsProvider =
    FutureProvider.autoDispose.family<List<SearchResult>, VaultItem>((ref, item) {
  return ref.watch(recommendationsRepositoryProvider).fetchForItem(item);
});

final vaultRecsProvider =
    FutureProvider.autoDispose.family<List<VaultItem>, VaultItem>((ref, item) async {
  final all = await ref.watch(vaultRepositoryProvider).getAll();
  return ref.watch(recommendationsRepositoryProvider).fetchVaultRecs(item, all);
});
