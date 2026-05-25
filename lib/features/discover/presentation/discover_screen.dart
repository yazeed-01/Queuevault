import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_env.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/network/search_result.dart';
import '../../../core/widgets/glow_card.dart';
import '../../vault/data/models/item_type.dart';

// ─── Filters ─────────────────────────────────────────────────────────────────

enum DiscoverFilter { movies, series, anime, games }

extension DiscoverFilterX on DiscoverFilter {
  String get label => switch (this) {
        DiscoverFilter.movies => 'Movies',
        DiscoverFilter.series => 'Series',
        DiscoverFilter.anime  => 'Anime',
        DiscoverFilter.games  => 'Games',
      };

  IconData get icon => switch (this) {
        DiscoverFilter.movies => Icons.movie_outlined,
        DiscoverFilter.series => Icons.tv_outlined,
        DiscoverFilter.anime  => Icons.auto_awesome_outlined,
        DiscoverFilter.games  => Icons.sports_esports_outlined,
      };
}

// ─── State ───────────────────────────────────────────────────────────────────

class DiscoverState {
  const DiscoverState({
    this.selected = const {
      DiscoverFilter.movies,
      DiscoverFilter.series,
      DiscoverFilter.anime,
      DiscoverFilter.games,
    },
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.pages = const {},
  });

  final Set<DiscoverFilter> selected;
  final List<SearchResult> items;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final Map<DiscoverFilter, int> pages;

  DiscoverState copyWith({
    Set<DiscoverFilter>? selected,
    List<SearchResult>? items,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    Map<DiscoverFilter, int>? pages,
  }) =>
      DiscoverState(
        selected: selected ?? this.selected,
        items: items ?? this.items,
        isLoading: isLoading ?? this.isLoading,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        hasMore: hasMore ?? this.hasMore,
        pages: pages ?? this.pages,
      );
}

// ─── Notifier ────────────────────────────────────────────────────────────────

class DiscoverNotifier extends StateNotifier<DiscoverState> {
  DiscoverNotifier() : super(const DiscoverState()) {
    _fetch(state.selected, replace: true);
  }

  Future<void> toggleFilter(DiscoverFilter filter) async {
    final next = Set<DiscoverFilter>.from(state.selected);
    if (next.contains(filter)) {
      if (next.length == 1) return; // keep at least one selected
      next.remove(filter);
    } else {
      next.add(filter);
    }
    state = DiscoverState(selected: next, isLoading: true);
    await _fetch(next, replace: true);
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.isLoading) return;
    state = state.copyWith(isLoadingMore: true);
    await _fetch(state.selected, replace: false);
  }

  Future<void> _fetch(Set<DiscoverFilter> filters, {required bool replace}) async {
    try {
      final pages = replace
          ? {for (final f in filters) f: 1}
          : {
              for (final f in filters)
                f: (state.pages[f] ?? 1) + 1,
            };

      final results = await Future.wait(
        filters.map((f) => _fetchForFilter(f, pages[f]!)),
      );

      // Interleave results so different categories appear mixed
      final newItems = _interleave(
        results.toList(),
        filters.toList(),
      );

      if (replace) {
        state = DiscoverState(
          selected: filters,
          items: newItems,
          isLoading: false,
          isLoadingMore: false,
          hasMore: newItems.isNotEmpty,
          pages: pages,
        );
      } else {
        state = state.copyWith(
          items: [...state.items, ...newItems],
          isLoadingMore: false,
          hasMore: newItems.isNotEmpty,
          pages: pages,
        );
      }
    } catch (_) {
      state = state.copyWith(isLoading: false, isLoadingMore: false);
    }
  }

  /// Round-robin interleave so cards from different categories mix together.
  List<SearchResult> _interleave(
    List<List<SearchResult>> batches,
    List<DiscoverFilter> filters,
  ) {
    final result = <SearchResult>[];
    final maxLen = batches.fold(0, (m, b) => m > b.length ? m : b.length);
    for (var i = 0; i < maxLen; i++) {
      for (final batch in batches) {
        if (i < batch.length) result.add(batch[i]);
      }
    }
    return result;
  }
}

final discoverProvider =
    StateNotifierProvider.autoDispose<DiscoverNotifier, DiscoverState>(
  (_) => DiscoverNotifier(),
);

// ─── API fetchers ─────────────────────────────────────────────────────────────

Future<List<SearchResult>> _fetchForFilter(DiscoverFilter f, int page) =>
    switch (f) {
      DiscoverFilter.movies => _fetchTmdb('movie', page),
      DiscoverFilter.series => _fetchTmdb('tv', page),
      DiscoverFilter.anime  => _fetchAnime(page),
      DiscoverFilter.games  => _fetchGames(page),
    };

Future<List<SearchResult>> _fetchTmdb(String type, int page) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString('tmdb_token')?.trim().isNotEmpty == true
        ? prefs.getString('tmdb_token')!
        : AppEnv.tmdbToken;
    if (key.isEmpty) return [];

    final dio = Dio(BaseOptions(baseUrl: ApiConstants.tmdbBase));
    final res = await dio.get(
      '/trending/$type/week',
      queryParameters: {'api_key': key, 'language': 'en-US', 'page': page},
    );
    final list = res.data['results'] as List;
    return list.map((r) {
      final isMovie = (r['media_type'] ?? type) == 'movie';
      final poster = r['poster_path'];
      final backdrop = r['backdrop_path'];
      return SearchResult(
        id: r['id'].toString(),
        title: isMovie ? (r['title'] ?? '') : (r['name'] ?? ''),
        type: isMovie ? ItemType.movie : ItemType.series,
        posterUrl: poster != null ? '${ApiConstants.tmdbPosterW500}$poster' : null,
        backdropUrl: backdrop != null ? '${ApiConstants.tmdbBackdropW1280}$backdrop' : null,
        overview: r['overview'],
        extraData: {'tmdb_id': r['id']},
      );
    }).toList();
  } catch (_) {
    return [];
  }
}

Future<List<SearchResult>> _fetchAnime(int page) async {
  try {
    final dio = Dio(BaseOptions(baseUrl: ApiConstants.anilistGraphql));
    final gql = '''
      query {
        Page(page: $page, perPage: 20) {
          media(type: ANIME, sort: TRENDING_DESC) {
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
          }
        }
      }
    ''';
    final res = await dio.post('', data: {'query': gql});
    final list = res.data['data']['Page']['media'] as List;
    return list.map((r) {
      final title = r['title']['english'] ?? r['title']['romaji'] ?? 'Unknown';
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
        },
      );
    }).toList();
  } catch (_) {
    return [];
  }
}

Future<List<SearchResult>> _fetchGames(int page) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString('rawg_key')?.trim().isNotEmpty == true
        ? prefs.getString('rawg_key')!
        : AppEnv.rawgKey;
    if (key.isEmpty) return [];

    final dio = Dio(BaseOptions(baseUrl: ApiConstants.rawgBase));
    final res = await dio.get('/games', queryParameters: {
      'key': key,
      'ordering': '-rating',
      'page_size': 20,
      'page': page,
    });
    final list = res.data['results'] as List;
    return list.map((r) {
      final genres =
          (r['genres'] as List?)?.map((g) => g['name'] as String).join(', ');
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
        },
      );
    }).toList();
  } catch (_) {
    return [];
  }
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 300) {
      ref.read(discoverProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(discoverProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: _scroll,
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: AppColors.background,
            title: Text('Discover', style: AppTextStyles.titleLarge),
          ),

          // ── Category chips ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: DiscoverFilter.values.map((f) {
                  final selected = state.selected.contains(f);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: selected,
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            f.icon,
                            size: 14,
                            color: selected
                                ? AppColors.primary
                                : AppColors.textMuted,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            f.label,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      onSelected: (_) => ref
                          .read(discoverProvider.notifier)
                          .toggleFilter(f),
                      backgroundColor: AppColors.surfaceLight,
                      selectedColor:
                          AppColors.primary.withValues(alpha: 0.15),
                      side: BorderSide(
                        color: selected
                            ? AppColors.primary.withValues(alpha: 0.5)
                            : AppColors.cardBorder,
                      ),
                      showCheckmark: false,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 4)),

          // ── Content ─────────────────────────────────────────────────────
          if (state.isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            )
          else if (state.items.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.explore_outlined,
                        size: 64, color: AppColors.textMuted),
                    const SizedBox(height: 12),
                    Text(
                      'No results — check API keys in Settings',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              ),
            )
          else ...[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              sliver: SliverGrid(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                delegate: SliverChildBuilderDelegate(
                  (_, i) =>
                      _DiscoverCard(result: state.items[i], index: i),
                  childCount: state.items.length,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                child: state.isLoadingMore
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primary),
                      )
                    : state.hasMore
                        ? OutlinedButton(
                            onPressed: () => ref
                                .read(discoverProvider.notifier)
                                .loadMore(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(
                                  color: AppColors.cardBorder),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12)),
                            ),
                            child: const Text('Load More'),
                          )
                        : Center(
                            child: Text('All caught up',
                                style: AppTextStyles.bodySmall),
                          ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Card ─────────────────────────────────────────────────────────────────────

class _DiscoverCard extends StatelessWidget {
  const _DiscoverCard({required this.result, required this.index});
  final SearchResult result;
  final int index;

  String get _typeLabel => switch (result.type) {
        ItemType.movie   => 'Movie',
        ItemType.series  => 'Series',
        ItemType.anime   => 'Anime',
        ItemType.game    => 'Game',
        ItemType.product => 'Product',
      };

  @override
  Widget build(BuildContext context) {
    return GlowCard(
      glowIntensity: 0.6,
      borderRadius: 14,
      onTap: () => context.push('/add',
          extra: {'type': result.type.name, 'url': result.posterUrl}),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(13)),
              child: result.posterUrl != null
                  ? CachedNetworkImage(
                      imageUrl: result.posterUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (_, __) =>
                          Container(color: AppColors.surfaceLight),
                      errorWidget: (_, __, ___) =>
                          Container(color: AppColors.surfaceLight),
                    )
                  : Container(color: AppColors.surfaceLight),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(result.title,
                    style: AppTextStyles.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(_typeLabel, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: (index % 20) * 40))
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.1, end: 0);
  }
}
