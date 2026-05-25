import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_env.dart';
import '../../../core/network/search_result.dart';
import '../../vault/data/models/item_type.dart';

class SearchService {
  SearchService();

  Future<List<SearchResult>> search(String query, ItemType type) async {
    if (query.trim().isEmpty) return [];
    return switch (type) {
      ItemType.movie => _searchTmdb(query, 'movie'),
      ItemType.series => _searchTmdb(query, 'tv'),
      ItemType.anime => _searchAnilist(query),
      ItemType.game => _searchRawg(query),
      ItemType.product => _searchUpcItemDb(query),
    };
  }

  Future<List<SearchResult>> _searchTmdb(String query, String mediaType) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = prefs.getString('tmdb_token')?.trim().isNotEmpty == true
          ? prefs.getString('tmdb_token')!
          : AppEnv.tmdbToken;
      if (key.isEmpty) return [];

      final dio = Dio(BaseOptions(baseUrl: ApiConstants.tmdbBase));

      final res = await dio.get('/search/$mediaType', queryParameters: {
        'query': query,
        'api_key': key,
        'language': 'en-US',
        'page': 1,
      });

      final results = (res.data['results'] as List).take(10).map((r) {
        final isMovie = mediaType == 'movie';
        final posterPath = r['poster_path'];
        final backdropPath = r['backdrop_path'];
        final releaseDate = isMovie
            ? (r['release_date'] ?? '')
            : (r['first_air_date'] ?? '');
        final year = releaseDate.length >= 4
            ? int.tryParse(releaseDate.substring(0, 4))
            : null;

        return SearchResult(
          id: r['id'].toString(),
          title: isMovie ? (r['title'] ?? '') : (r['name'] ?? ''),
          type: isMovie ? ItemType.movie : ItemType.series,
          posterUrl: posterPath != null
              ? '${ApiConstants.tmdbPosterW500}$posterPath'
              : null,
          backdropUrl: backdropPath != null
              ? '${ApiConstants.tmdbBackdropW1280}$backdropPath'
              : null,
          overview: r['overview'],
          year: year,
          genre: null,
          extraData: {
            'tmdb_id': r['id'],
            'vote_average': r['vote_average'],
          },
        );
      }).toList();

      return results;
    } catch (_) {
      return [];
    }
  }

  Future<List<SearchResult>> _searchAnilist(String query) async {
    try {
      final dio = Dio(BaseOptions(baseUrl: ApiConstants.anilistGraphql));
      const gql = r'''
        query ($search: String) {
          Page(page: 1, perPage: 10) {
            media(search: $search, type: ANIME) {
              id
              title { english romaji }
              coverImage { large }
              bannerImage
              description(asHtml: false)
              episodes
              format
              status
              startDate { year }
              genres
              nextAiringEpisode { episode airingAt }
            }
          }
        }
      ''';

      final res = await dio.post('',
          data: {'query': gql, 'variables': {'search': query}});

      final list = res.data['data']['Page']['media'] as List;
      return list.map((r) {
        final title =
            r['title']['english'] ?? r['title']['romaji'] ?? 'Unknown';
        final next = r['nextAiringEpisode'];
        return SearchResult(
          id: r['id'].toString(),
          title: title,
          type: ItemType.anime,
          posterUrl: r['coverImage']['large'],
          backdropUrl: r['bannerImage'],
          overview: r['description'],
          year: r['startDate']?['year'],
          genre: (r['genres'] as List?)?.join(', '),
          extraData: {
            'anilist_id': r['id'],
            'total_episodes': r['episodes'],
            'format': r['format'],
            'status': r['status'],
            'next_airing_episode': next?['episode'],
            'next_airing_at': next?['airingAt'],
          },
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<SearchResult>> _searchRawg(String query) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = prefs.getString('rawg_key')?.trim().isNotEmpty == true
          ? prefs.getString('rawg_key')!
          : AppEnv.rawgKey;
      if (key.isEmpty) return [];

      final dio = Dio(BaseOptions(baseUrl: ApiConstants.rawgBase));
      final res = await dio.get('/games', queryParameters: {
        'search': query,
        'key': key,
        'page_size': 10,
      });

      final list = res.data['results'] as List;
      return list.map((r) {
        final genres = (r['genres'] as List?)
            ?.map((g) => g['name'] as String)
            .join(', ');
        final platforms = (r['platforms'] as List?)
            ?.map((p) => p['platform']['name'] as String)
            .take(3)
            .join(', ');
        return SearchResult(
          id: r['id'].toString(),
          title: r['name'] ?? '',
          type: ItemType.game,
          posterUrl: r['background_image'],
          overview: null,
          year: r['released'] != null && (r['released'] as String).length >= 4
              ? int.tryParse((r['released'] as String).substring(0, 4))
              : null,
          genre: genres,
          extraData: {
            'rawg_id': r['id'],
            'metacritic': r['metacritic'],
            'playtime': r['playtime'],
            'platforms': platforms,
          },
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<SearchResult>> _searchUpcItemDb(String query) async {
    try {
      final dio = Dio(BaseOptions(
        baseUrl: 'https://api.upcitemdb.com/prod/trial',
        headers: {'User-Agent': 'QueueVault/1.0'},
      ));

      final res = await dio.get('/search', queryParameters: {
        's': query,
        'type': 'product',
      });

      final list = (res.data['items'] as List?) ?? [];
      return list.take(10).map((r) {
        final images = (r['images'] as List?)?.cast<String>() ?? [];
        final offers = (r['offers'] as List?) ?? [];
        final price = offers.isNotEmpty
            ? (offers.first['price'] as num?)?.toDouble()
            : null;
        final storeUrl = offers.isNotEmpty
            ? offers.first['link'] as String?
            : null;

        return SearchResult(
          id: r['upc'] ?? r['ean'] ?? '',
          title: r['title'] ?? '',
          type: ItemType.product,
          posterUrl: images.isNotEmpty ? images.first : null,
          overview: r['description'],
          extraData: {
            'brand': r['brand'],
            'price': price,
            'store_url': storeUrl,
          },
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }
}

final searchServiceProvider = Provider<SearchService>((ref) => SearchService());

final searchQueryProvider = StateProvider<String>((ref) => '');
final searchTypeProvider = StateProvider<ItemType>((ref) => ItemType.movie);

final searchResultsProvider =
    FutureProvider.autoDispose<List<SearchResult>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  final type = ref.watch(searchTypeProvider);
  if (query.trim().isEmpty) return [];
  return ref.watch(searchServiceProvider).search(query, type);
});
