import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/utils/item_images.dart';
import '../../../../core/widgets/category_badge.dart';
import '../../data/models/item_type.dart';
import '../../domain/layout_preferences_provider.dart';
import '../../domain/vault_providers.dart';
import '../vault_item_mini_card.dart';
import '../widgets/vault_app_bar.dart';

class DeckSpotlightLayout extends ConsumerWidget {
  const DeckSpotlightLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allAsync = ref.watch(allVaultStreamProvider);

    return CustomScrollView(
      slivers: [
        const VaultSliverAppBar(),
        allAsync.when(
          data: (items) {
            if (items.isEmpty) {
              return const SliverFillRemaining(child: _EmptyState());
            }
            return _DeckSlivers(items: items);
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

class _DeckSlivers extends StatelessWidget {
  const _DeckSlivers({required this.items});
  final List<VaultItem> items;

  @override
  Widget build(BuildContext context) {
    final inProgress =
        items.where((i) => i.status == ItemStatus.inProgress.value).toList();
    final queued =
        items.where((i) => i.status == ItemStatus.want.value).toList();
    final completed =
        items.where((i) => i.status == ItemStatus.completed.value).toList();
    final dropped =
        items.where((i) => i.status == ItemStatus.dropped.value).toList();

    return SliverList(
      delegate: SliverChildListDelegate([
        // ── Spotlight deck ──────────────────────────────────────────────
        if (inProgress.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                const Icon(Icons.play_circle_rounded,
                    size: 15, color: AppColors.accent),
                const SizedBox(width: 6),
                Text(
                  'Now Playing',
                  style: AppTextStyles.titleSmall
                      .copyWith(color: AppColors.accent),
                ),
                const SizedBox(width: 6),
                Text(
                  '${inProgress.length} active',
                  style:
                      AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _SpotlightDeck(items: inProgress),
          const SizedBox(height: 8),
        ] else ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: _NoActiveCard(),
          ),
        ],

        // ── Queued ───────────────────────────────────────────────────────
        if (queued.isNotEmpty) ...[
          _StatusSection(
            title: 'Up Next',
            icon: Icons.queue_rounded,
            color: AppColors.primary,
            items: queued,
          ),
        ],

        // ── Completed ────────────────────────────────────────────────────
        if (completed.isNotEmpty) ...[
          _StatusSection(
            title: 'Completed',
            icon: Icons.check_circle_outline_rounded,
            color: AppColors.success,
            items: completed,
          ),
        ],

        // ── Dropped ──────────────────────────────────────────────────────
        if (dropped.isNotEmpty) ...[
          _StatusSection(
            title: 'Dropped',
            icon: Icons.cancel_outlined,
            color: AppColors.textMuted,
            items: dropped,
          ),
        ],

        const SizedBox(height: 100),
      ]),
    );
  }
}

// ─── Swipeable deck of in-progress items ─────────────────────────────────────

class _SpotlightDeck extends ConsumerStatefulWidget {
  const _SpotlightDeck({required this.items});
  final List<VaultItem> items;

  @override
  ConsumerState<_SpotlightDeck> createState() => _SpotlightDeckState();
}

class _SpotlightDeckState extends ConsumerState<_SpotlightDeck> {
  final _controller = PageController(viewportFraction: 0.88);
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 230,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.items.length,
            onPageChanged: (p) => setState(() => _currentPage = p),
            itemBuilder: (context, i) {
              return AnimatedScale(
                scale: i == _currentPage ? 1.0 : 0.93,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                child: _SpotlightCard(item: widget.items[i]),
              );
            },
          ),
        ),
        if (widget.items.length > 1) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.items.length, (i) {
              final active = i == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: active ? AppColors.accent : AppColors.textMuted,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}

class _SpotlightCard extends ConsumerWidget {
  const _SpotlightCard({required this.item});
  final VaultItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(layoutPrefsProvider);
    final type = ItemTypeExt.fromString(item.itemType);
    final progress = _calcProgress();
    final glowColor = _glowForType(type);
    final posterProvider = itemPosterProvider(item);

    return GestureDetector(
      onTap: () => context.push('/item/${item.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: glowColor.withValues(alpha: 0.4)),
            boxShadow: [
              BoxShadow(
                color: glowColor.withValues(alpha: 0.25),
                blurRadius: 20,
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Row(
              children: [
                // Poster
                SizedBox(
                  width: 120,
                  child: posterProvider != null
                      ? (prefs.heroTransitions
                          ? Hero(
                              tag: 'vault_poster_${item.id}',
                              child: Image(
                                image: posterProvider,
                                fit: BoxFit.cover,
                                height: double.infinity,
                                errorBuilder: (_, __, ___) => Container(
                                  color: AppColors.surfaceLight,
                                  child: Center(
                                    child: Icon(_iconForType(type),
                                        size: 36, color: AppColors.textMuted),
                                  ),
                                ),
                              ),
                            )
                          : Image(
                              image: posterProvider,
                              fit: BoxFit.cover,
                              height: double.infinity,
                              errorBuilder: (_, __, ___) => Container(
                                color: AppColors.surfaceLight,
                                child: Center(
                                  child: Icon(_iconForType(type),
                                      size: 36, color: AppColors.textMuted),
                                ),
                              ),
                            ))
                      : Container(
                          color: AppColors.surfaceLight,
                          child: Center(
                            child: Icon(_iconForType(type),
                                size: 36, color: AppColors.textMuted),
                          ),
                        ),
                ),

                // Info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CategoryBadge(type: type),
                        const SizedBox(height: 8),
                        Text(
                          item.title,
                          style: AppTextStyles.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item.overview != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            item.overview!,
                            style: AppTextStyles.bodySmall,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const Spacer(),
                        if (progress != null) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor:
                                  AppColors.surfaceLight,
                              valueColor: AlwaysStoppedAnimation(glowColor),
                              minHeight: 4,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(progress * 100).round()}% complete',
                            style: AppTextStyles.bodySmall
                                .copyWith(color: glowColor),
                          ),
                        ] else
                          Text(
                            'In Progress',
                            style: AppTextStyles.bodySmall
                                .copyWith(color: glowColor),
                          ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: glowColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: glowColor.withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.open_in_new_rounded,
                                  size: 13, color: glowColor),
                              const SizedBox(width: 4),
                              Text('Open',
                                  style: AppTextStyles.labelSmall
                                      .copyWith(color: glowColor, fontSize: 10)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms)
            .slideX(begin: 0.05, end: 0, curve: Curves.easeOutCubic),
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

  Color _glowForType(ItemType type) => switch (type) {
        ItemType.movie => AppColors.watchColor,
        ItemType.series  => AppColors.seriesColor,
        ItemType.anime => AppColors.animeColor,
        ItemType.game => AppColors.playColor,
        ItemType.product => AppColors.buyColor,
      };

  IconData _iconForType(ItemType type) => switch (type) {
        ItemType.movie => Icons.movie_rounded,
        ItemType.series => Icons.tv_rounded,
        ItemType.anime => Icons.auto_awesome,
        ItemType.game => Icons.sports_esports_rounded,
        ItemType.product => Icons.shopping_bag_rounded,
      };
}

// ─── Status section (queued / completed / dropped) ───────────────────────────

class _StatusSection extends StatelessWidget {
  const _StatusSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });

  final String title;
  final IconData icon;
  final Color color;
  final List<VaultItem> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(icon, size: 15, color: color),
                const SizedBox(width: 8),
                Text(title,
                    style: AppTextStyles.titleSmall.copyWith(color: color)),
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('${items.length}',
                      style: AppTextStyles.labelSmall
                          .copyWith(color: color, fontSize: 10)),
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

// ─── No active items placeholder ─────────────────────────────────────────────

class _NoActiveCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: AppColors.accent.withValues(alpha: 0.2), style: BorderStyle.solid),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.play_circle_outline_rounded,
                size: 28, color: AppColors.textMuted),
            const SizedBox(height: 8),
            Text('Nothing in progress',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textMuted)),
          ],
        ),
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
