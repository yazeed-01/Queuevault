import 'package:cached_network_image/cached_network_image.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/database/app_database.dart';
import '../../../core/network/search_result.dart';
import '../../../core/widgets/glow_card.dart';
import '../../vault/data/models/item_type.dart';
import '../../vault/domain/vault_providers.dart';
import '../data/search_service.dart';

class AddItemScreen extends ConsumerStatefulWidget {
  const AddItemScreen({super.key, this.preselectedType, this.sharedUrl, this.initialQuery});

  final String? preselectedType;
  final String? sharedUrl;
  final String? initialQuery;

  @override
  ConsumerState<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends ConsumerState<AddItemScreen> {
  late ItemType _selectedType;
  final _searchCtrl = TextEditingController();
  var _debounce = 0;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.preselectedType != null
        ? ItemTypeExt.fromString(widget.preselectedType!)
        : ItemType.movie;

    if (widget.sharedUrl != null) {
      _searchCtrl.text = widget.sharedUrl!;
    } else if (widget.initialQuery != null) {
      _searchCtrl.text = widget.initialQuery!;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchTypeProvider.notifier).state = _selectedType;
      if (widget.sharedUrl != null) {
        ref.read(searchQueryProvider.notifier).state = widget.sharedUrl!;
      } else if (widget.initialQuery != null) {
        ref.read(searchQueryProvider.notifier).state = widget.initialQuery!;
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {});
    final tick = ++_debounce;
    Future.delayed(const Duration(milliseconds: 350), () {
      if (tick == _debounce) {
        ref.read(searchQueryProvider.notifier).state = query;
      }
    });
  }

  Color get _typeColor => switch (_selectedType) {
        ItemType.movie || ItemType.series => AppColors.watchColor,
        ItemType.anime => AppColors.animeColor,
        ItemType.game => AppColors.playColor,
        ItemType.product => AppColors.buyColor,
      };

  Future<void> _quickAdd(String title) async {
    if (title.trim().isEmpty) return;
    HapticFeedback.mediumImpact();
    final repo = ref.read(vaultRepositoryProvider);
    final id = await repo.add(VaultItemsCompanion.insert(
      itemType: _selectedType.value,
      title: title.trim(),
    ));
    if (mounted) {
      context.pushReplacement('/item/$id');
    }
  }

  Future<void> _addFromResult(SearchResult result) async {
    HapticFeedback.mediumImpact();
    final repo = ref.read(vaultRepositoryProvider);
    await repo.add(_resultToCompanion(result));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"${result.title}" added to Vault')),
      );
      context.pop();
    }
  }

  VaultItemsCompanion _resultToCompanion(SearchResult r) =>
      VaultItemsCompanion.insert(
        itemType: r.type.value,
        title: r.title,
        posterUrl: Value(r.posterUrl),
        backdropUrl: Value(r.backdropUrl),
        overview: Value(r.overview),
        externalId: Value(r.id),
        releaseYear: Value(r.year),
        genre: Value(r.genre),
        anilistId: Value(r.extraData['anilist_id'] as int?),
        totalEpisodesAnime: Value(r.extraData['total_episodes'] as int?),
        animeFormat: Value(r.extraData['format'] as String?),
        airingStatus: Value(r.extraData['status'] as String?),
        nextAiringEpisode: Value(r.extraData['next_airing_episode'] as int?),
        nextAiringAt: Value(
          r.extraData['next_airing_at'] != null
              ? DateTime.fromMillisecondsSinceEpoch(
                  (r.extraData['next_airing_at'] as int) * 1000)
              : null,
        ),
        metacriticScore: Value(r.extraData['metacritic'] as int?),
        estimatedPlaytimeHours: Value(r.extraData['playtime'] as int?),
        platform: Value(r.extraData['platforms'] as String?),
        targetPrice: Value(
          r.extraData['price'] != null
              ? (r.extraData['price'] as num).toDouble()
              : null,
        ),
        storeUrl: Value(r.extraData['store_url'] as String?),
      );

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchResultsProvider);
    final query = _searchCtrl.text.trim();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            Icon(Icons.bolt, color: _typeColor, size: 20),
            const SizedBox(width: 6),
            Text('Add', style: AppTextStyles.titleLarge),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.cardBorder),
        ),
      ),
      body: Column(
        children: [
          // Type selector
          _TypeBar(
            selected: _selectedType,
            onSelect: (t) {
              setState(() => _selectedType = t);
              ref.read(searchTypeProvider.notifier).state = t;
              ref.read(searchQueryProvider.notifier).state = _searchCtrl.text;
            },
          ),

          // Category context hint
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
            child: Row(
              children: [
                Icon(Icons.folder_outlined, size: 13, color: _typeColor.withValues(alpha: 0.8)),
                const SizedBox(width: 5),
                Text(
                  'Adding to ${_labelFor(_selectedType)}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: _typeColor.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                Text('·', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
                const SizedBox(width: 6),
                Text(
                  'Tap another tab to change',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ).animate(key: ValueKey(_selectedType)).fadeIn(duration: 200.ms),

          // Search field
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _searchCtrl,
              onChanged: _onSearch,
              autofocus: true,
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: _hintFor(_selectedType),
                prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                suffixIcon: query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.textMuted),
                        onPressed: () {
                          _searchCtrl.clear();
                          _onSearch('');
                          ref.read(searchQueryProvider.notifier).state = '';
                        },
                      )
                    : null,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 4),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 12, color: AppColors.textMuted),
                const SizedBox(width: 5),
                Text(
                  'Search shows results with poster, details & more',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),

          // Results
          Expanded(
            child: results.when(
              data: (list) => list.isEmpty && query.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search, size: 52, color: AppColors.textMuted),
                          const SizedBox(height: 12),
                          Text('Search or type to quick-add',
                              style: AppTextStyles.bodyMedium),
                        ],
                      ),
                    )
                  : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                itemCount: list.length + (query.isNotEmpty ? 1 : 0),
                itemBuilder: (_, i) {
                  // First row: always quick-add if there's a query
                  if (query.isNotEmpty && i == 0) {
                    return _QuickAddTile(
                      title: query,
                      type: _selectedType,
                      color: _typeColor,
                      onTap: () => _quickAdd(query),
                    ).animate().fadeIn(duration: 200.ms);
                  }
                  final result = list[query.isNotEmpty ? i - 1 : i];
                  return _ResultTile(
                    result: result,
                    index: i,
                    onAdd: () => _addFromResult(result),
                  );
                },
              ),
              loading: () => ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                itemCount: query.isNotEmpty ? 6 : 0,
                itemBuilder: (_, i) => i == 0 && query.isNotEmpty
                    ? _QuickAddTile(
                        title: query,
                        type: _selectedType,
                        color: _typeColor,
                        onTap: () => _quickAdd(query),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.shimmerBase,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ).animate(onPlay: (c) => c.repeat()).shimmer(
                              duration: 1200.ms,
                              color: AppColors.shimmerHighlight,
                            ),
                      ),
              ),
              error: (_, __) => query.isNotEmpty
                  ? ListView(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      children: [
                        _QuickAddTile(
                          title: query,
                          type: _selectedType,
                          color: _typeColor,
                          onTap: () => _quickAdd(query),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  String _hintFor(ItemType t) => switch (t) {
        ItemType.movie => 'Search movie or type to quick-add...',
        ItemType.series => 'Search series or type to quick-add...',
        ItemType.anime => 'Search anime or type to quick-add...',
        ItemType.game => 'Search game or type to quick-add...',
        ItemType.product => 'Search product or type to quick-add...',
      };

  String _labelFor(ItemType t) => switch (t) {
        ItemType.movie => 'Movies',
        ItemType.series => 'Series',
        ItemType.anime => 'Anime',
        ItemType.game => 'Games',
        ItemType.product => 'Products',
      };
}

// First tile — always visible when query is non-empty
class _QuickAddTile extends StatelessWidget {
  const _QuickAddTile({
    required this.title,
    required this.type,
    required this.color,
    required this.onTap,
  });
  final String title;
  final ItemType type;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.35)),
          ),
          child: Row(
            children: [
              Icon(Icons.add_circle_outline, color: color, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick add "$title"',
                      style: AppTextStyles.titleSmall.copyWith(color: color),
                    ),
                    Text(
                      'Saved to vault. To edit or add details, go to home, press on it and hit the Edit button.',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(Icons.bolt, color: color, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeBar extends StatelessWidget {
  const _TypeBar({required this.selected, required this.onSelect});
  final ItemType selected;
  final void Function(ItemType) onSelect;

  static const _types = [
    (ItemType.movie, 'Movie', Icons.movie_rounded),
    (ItemType.series, 'Series', Icons.tv_rounded),
    (ItemType.anime, 'Anime', Icons.auto_awesome),
    (ItemType.game, 'Game', Icons.sports_esports_rounded),
    (ItemType.product, 'Product', Icons.shopping_bag_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        children: _types.map((t) {
          final (type, label, icon) = t;
          final sel = selected == type;
          final color = _color(type);
          return GestureDetector(
            onTap: () => onSelect(type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: sel ? color.withValues(alpha: 0.15) : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: sel ? color.withValues(alpha: 0.5) : AppColors.cardBorder,
                  width: sel ? 1.5 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 14, color: sel ? color : AppColors.textMuted),
                  const SizedBox(width: 6),
                  Text(label,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: sel ? color : AppColors.textMuted,
                        fontSize: 12,
                      )),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _color(ItemType t) => switch (t) {
        ItemType.movie || ItemType.series => AppColors.watchColor,
        ItemType.anime => AppColors.animeColor,
        ItemType.game => AppColors.playColor,
        ItemType.product => AppColors.buyColor,
      };
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({required this.result, required this.index, required this.onAdd});
  final SearchResult result;
  final int index;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlowCard(
        glowIntensity: 0.4,
        child: ListTile(
          contentPadding: const EdgeInsets.all(10),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: result.posterUrl != null
                ? CachedNetworkImage(
                    imageUrl: result.posterUrl!,
                    width: 46,
                    height: 66,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => _placeholder,
                    errorWidget: (_, __, ___) => _placeholder,
                  )
                : _placeholder,
          ),
          title: Text(result.title,
              style: AppTextStyles.titleSmall, maxLines: 2,
              overflow: TextOverflow.ellipsis),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (result.year != null)
                Text('${result.year}', style: AppTextStyles.bodySmall),
              if (result.genre != null)
                Text(result.genre!, style: AppTextStyles.bodySmall,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
          trailing: GestureDetector(
            onTap: onAdd,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.primaryGlow,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
              ),
              child: const Icon(Icons.add, color: AppColors.primary, size: 18),
            ),
          ),
        ),
      )
          .animate(delay: Duration(milliseconds: index * 35))
          .fadeIn(duration: 220.ms)
          .slideX(begin: 0.04, end: 0),
    );
  }

  Widget get _placeholder => Container(
        width: 46,
        height: 66,
        color: AppColors.surfaceLight,
        child: const Icon(Icons.image_not_supported,
            color: AppColors.textMuted, size: 18),
      );
}
