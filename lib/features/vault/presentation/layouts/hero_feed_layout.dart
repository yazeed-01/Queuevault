import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/utils/item_images.dart';
import '../../../../core/utils/category_icons.dart';
import '../../../../core/widgets/category_badge.dart';
import '../../data/models/item_type.dart';
import '../../domain/layout_preferences_provider.dart';
import '../../domain/vault_providers.dart';
import '../vault_item_mini_card.dart';
import '../widgets/vault_app_bar.dart';

class HeroFeedLayout extends ConsumerWidget {
  const HeroFeedLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allAsync = ref.watch(allVaultStreamProvider);
    final categoriesAsync = ref.watch(categoriesStreamProvider);

    return CustomScrollView(
      slivers: [
        const VaultSliverAppBar(),
        allAsync.when(
          data: (items) {
            if (items.isEmpty) {
              return const SliverFillRemaining(child: _EmptyState());
            }
            return categoriesAsync.when(
              data: (cats) => _HeroFeedSlivers(items: items, categories: cats),
              loading: () => const SliverToBoxAdapter(child: SizedBox()),
              error: (_, __) => const SliverToBoxAdapter(child: SizedBox()),
            );
          },
          loading: () => const SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
          ),
          error: (e, _) => SliverFillRemaining(
            child: Center(
                child: Text('Error: $e', style: AppTextStyles.bodyMedium)),
          ),
        ),
      ],
    );
  }

}

class _HeroFeedSlivers extends StatelessWidget {
  const _HeroFeedSlivers({required this.items, required this.categories});

  final List<VaultItem> items;
  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    final inProgress = items
        .where((i) => i.status == ItemStatus.inProgress.value)
        .toList();
    final hero = inProgress.isNotEmpty ? inProgress.first : null;

    // Category rows — exclude any item already shown as hero
    final catRows = <(Category, List<VaultItem>)>[];
    for (final cat in categories) {
      final catItems = items
          .where((i) =>
              i.itemType == cat.typeKey &&
              (hero == null || i.id != hero.id))
          .toList();
      if (catItems.isNotEmpty) catRows.add((cat, catItems));
    }

    return SliverList(
      delegate: SliverChildListDelegate([
        if (hero != null)
          _HeroCard(item: hero)
              .animate()
              .fadeIn(duration: 500.ms)
              .slideY(begin: 0.05, end: 0, curve: Curves.easeOutCubic),
        ...catRows.asMap().entries.map((entry) {
          final (cat, catItems) = entry.value;
          final color = _hexToColor(cat.colorHex);
          return _CategoryRow(
            category: cat,
            color: color,
            items: catItems,
          );
        }),
        const SizedBox(height: 100),
      ]),
    );
  }
}

// ─── Full-width cinematic hero card ─────────────────────────────────────────

class _HeroCard extends ConsumerWidget {
  const _HeroCard({required this.item});
  final VaultItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(layoutPrefsProvider);
    final type = ItemTypeExt.fromString(item.itemType);
    final status = ItemStatusExt.fromString(item.status);
    final progress = _calcProgress();
    final posterProvider = itemPosterProvider(item);

    return GestureDetector(
      onTap: () => context.push('/item/${item.id}'),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: 280,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Blurred backdrop
                if (posterProvider != null)
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Image(
                      image: posterProvider,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: AppColors.surfaceLight),
                    ),
                  )
                else
                  Container(color: AppColors.surfaceLight),

                // Dark scrim
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                ),

                // Content row
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Poster thumbnail
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 110,
                          height: 160,
                          child: posterProvider != null
                              ? (prefs.heroTransitions
                                  ? Hero(
                                      tag: 'vault_poster_${item.id}',
                                      child: Image(
                                        image: posterProvider,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            Container(
                                                color: AppColors.surfaceLight),
                                      ),
                                    )
                                  : Image(
                                      image: posterProvider,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          Container(
                                              color: AppColors.surfaceLight),
                                    ))
                              : Container(
                                  color: AppColors.surfaceLight,
                                  child: Icon(Icons.movie_rounded,
                                      size: 36, color: AppColors.textMuted),
                                ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Text info
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CategoryBadge(type: type),
                            const SizedBox(height: 8),
                            Text(
                              item.title,
                              style: AppTextStyles.titleLarge,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            if (item.overview != null) ...[
                              Text(
                                item.overview!,
                                style: AppTextStyles.bodySmall,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 10),
                            ],
                            if (progress != null) ...[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor:
                                      Colors.white.withValues(alpha: 0.2),
                                  valueColor: const AlwaysStoppedAnimation(
                                      AppColors.accent),
                                  minHeight: 4,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${(progress * 100).round()}% complete',
                                style: AppTextStyles.bodySmall
                                    .copyWith(color: AppColors.accent),
                              ),
                            ] else
                              Text(
                                status.label,
                                style: AppTextStyles.bodySmall
                                    .copyWith(color: AppColors.accent),
                              ),
                            const SizedBox(height: 12),
                            // CTA
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: AppColors.accent
                                        .withValues(alpha: 0.5)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.play_arrow_rounded,
                                      size: 16, color: AppColors.accent),
                                  const SizedBox(width: 4),
                                  Text('Continue',
                                      style: AppTextStyles.labelSmall
                                          .copyWith(color: AppColors.accent)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double? _calcProgress() {
    final type = ItemTypeExt.fromString(item.itemType);
    return switch (type) {
      ItemType.series =>
        item.totalEpisodes != null && item.totalEpisodes! > 0
            ? (item.currentEpisode ?? 0) / item.totalEpisodes!
            : null,
      ItemType.anime =>
        item.totalEpisodesAnime != null && item.totalEpisodesAnime! > 0
            ? (item.currentEpisodeAnime ?? 0) / item.totalEpisodesAnime!
            : null,
      ItemType.game => item.completionPercent != null
          ? item.completionPercent! / 100.0
          : null,
      _ => null,
    };
  }
}

// ─── Compact category row ────────────────────────────────────────────────────

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.category,
    required this.color,
    required this.items,
  });

  final Category category;
  final Color color;
  final List<VaultItem> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(CategoryIcons.resolve(category.iconName),
                    size: 15, color: color),
                const SizedBox(width: 8),
                Text(
                  category.name,
                  style:
                      AppTextStyles.titleSmall.copyWith(color: color),
                ),
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${items.length}',
                    style: AppTextStyles.labelSmall
                        .copyWith(color: color, fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 210,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, i) =>
                  VaultItemMiniCard(item: items[i], index: i),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.video_library_outlined,
              size: 64, color: AppColors.textMuted),
          const SizedBox(height: 16),
          Text('Your vault is empty', style: AppTextStyles.titleMedium),
          const SizedBox(height: 8),
          Text('Tap + to quick-add', style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}

Color _hexToColor(String hex) {
  final clean = hex.replaceAll('#', '');
  return Color(int.parse(clean.length == 6 ? 'FF$clean' : clean, radix: 16));
}
