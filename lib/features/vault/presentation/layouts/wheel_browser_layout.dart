import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../domain/vault_providers.dart';
import '../widgets/design_picker_sheet.dart';

class WheelBrowserLayout extends ConsumerStatefulWidget {
  const WheelBrowserLayout({super.key});

  @override
  ConsumerState<WheelBrowserLayout> createState() =>
      _WheelBrowserLayoutState();
}

class _WheelBrowserLayoutState extends ConsumerState<WheelBrowserLayout>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowCtrl;

  // One FixedExtentScrollController per category page
  final List<FixedExtentScrollController> _wheelControllers = [];

  // Selected item index per category page
  final List<int> _itemIndices = [];

  // Vertical page controller (one page = one category)
  final PageController _pageCtrl = PageController();
  int _pageIndex = 0;

  // Cached category+items list so we can dispose controllers correctly
  List<(Category, List<VaultItem>)> _pages = [];

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    _pageCtrl.dispose();
    for (final c in _wheelControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _syncControllers(List<(Category, List<VaultItem>)> pages) {
    // Always handle page count changes (new category appeared or disappeared)
    if (pages.length != _pages.length) {
      for (final c in _wheelControllers) {
        c.dispose();
      }
      _wheelControllers.clear();
      _itemIndices.clear();

      for (int i = 0; i < pages.length; i++) {
        _wheelControllers.add(FixedExtentScrollController());
        _itemIndices.add(0);
      }
      _pages = pages;
      return;
    }

    // Same page count — check each category for newly added items and
    // jump the wheel to the new last item so the hero updates immediately.
    for (int i = 0; i < pages.length; i++) {
      final newItems = pages[i].$2;
      final oldItems = _pages.isNotEmpty ? _pages[i].$2 : <VaultItem>[];

      if (newItems.length > oldItems.length) {
        // A new item was added — jump wheel to the end (newest item)
        final newIdx = newItems.length - 1;
        _itemIndices[i] = newIdx;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_wheelControllers.length > i &&
              _wheelControllers[i].hasClients) {
            _wheelControllers[i].jumpToItem(newIdx);
          }
        });
      } else if (newItems.length < oldItems.length) {
        // An item was deleted — clamp index so it never goes out of range
        _itemIndices[i] = _itemIndices[i].clamp(0, newItems.length - 1);
      }
    }
    _pages = pages;
  }


  void _onCategoryChanged(int page) {
    HapticFeedback.lightImpact();
    setState(() => _pageIndex = page.clamp(0, _pages.length - 1));
  }

  void _onItemChanged(int catIdx, int itemIdx) {
    HapticFeedback.selectionClick();
    setState(() {
      _itemIndices[catIdx] =
          itemIdx.clamp(0, _pages[catIdx].$2.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final allAsync = ref.watch(allVaultStreamProvider);
    final catsAsync = ref.watch(categoriesStreamProvider);

    // Jump to a specific category when requested (e.g. from Discover → Go to Vault)
    final jumpTo = ref.watch(vaultJumpToTypeProvider);


    return allAsync.when(
      data: (allItems) {
        if (allItems.isEmpty) return const _EmptyState();

        return catsAsync.when(
          data: (cats) {
            // Build pages: only categories that have items
            final pages = <(Category, List<VaultItem>)>[];
            for (final cat in cats) {
              final items = allItems
                  .where((i) => i.itemType == cat.typeKey)
                  .toList();
              if (items.isNotEmpty) pages.add((cat, items));
            }
            if (pages.isEmpty) return const _EmptyState();

            // Sync controllers whenever page count changes
            _syncControllers(pages);

            // Jump to requested category (set by "Go to Vault" from Discover)
            if (jumpTo != null) {
              final targetPage = pages.indexWhere((p) => p.$1.typeKey == jumpTo);
              if (targetPage >= 0 && targetPage != _pageIndex) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_pageCtrl.hasClients) {
                    _pageCtrl.animateToPage(
                      targetPage,
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.easeOutCubic,
                    );
                  }
                  // Clear so it doesn't re-trigger on next rebuild
                  ref.read(vaultJumpToTypeProvider.notifier).state = null;
                });
              } else {
                // Already on the right page — just clear
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref.read(vaultJumpToTypeProvider.notifier).state = null;
                });
              }
            }

            final safePageIdx = _pageIndex.clamp(0, pages.length - 1);

            final (currentCat, currentItems) = pages[safePageIdx];
            final safeItemIdx =
                _itemIndices[safePageIdx].clamp(0, currentItems.length - 1);
            final currentItem = currentItems[safeItemIdx];
            final backdropProvider = itemBackdropProvider(currentItem);
            final catColor = _hexToColor(currentCat.colorHex);

            return Stack(
              children: [
                // ── Blurred backdrop ────────────────────────────────────
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: backdropProvider != null
                      ? SizedBox.expand(
                          key: ValueKey(currentItem.id),
                          child: ImageFiltered(
                            imageFilter:
                                ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                            child: Image(
                              image: backdropProvider,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  Container(color: AppColors.surfaceLight),
                            ),
                          ),
                        )
                      : SizedBox.expand(
                          key: ValueKey('blank_${currentItem.id}')),
                ),

                // Dark scrim
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.background.withValues(alpha: 0.82),
                        AppColors.background.withValues(alpha: 0.96),
                      ],
                    ),
                  ),
                ),

                // Ambient glow orb
                AnimatedBuilder(
                  animation: _glowCtrl,
                  builder: (_, __) => Positioned(
                    top: 80,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              catColor.withValues(
                                  alpha: 0.09 + _glowCtrl.value * 0.05),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Main content ────────────────────────────────────────
                SafeArea(
                  child: Row(
                    children: [
                      // Left: app bar + detail + wheel (vertical page)
                      Expanded(
                        child: Column(
                          children: [
                            _WheelAppBar(glowCtrl: _glowCtrl),
                            const SizedBox(height: 6),

                            // Vertical page view — one page per category
                            Expanded(
                              child: PageView.builder(
                                controller: _pageCtrl,
                                scrollDirection: Axis.vertical,
                                itemCount: pages.length,
                                onPageChanged: _onCategoryChanged,
                                itemBuilder: (context, catIdx) {
                                  final (cat, catItems) = pages[catIdx];
                                  final safeIdx = _itemIndices[catIdx]
                                      .clamp(0, catItems.length - 1);
                                  final item = catItems[safeIdx];
                                  final color = _hexToColor(cat.colorHex);

                                  return _CategoryPage(
                                    cat: cat,
                                    catColor: color,
                                    items: catItems,
                                    currentIndex: safeIdx,
                                    wheelController:
                                        _wheelControllers[catIdx],
                                    glowCtrl: _glowCtrl,
                                    currentItem: item,
                                    glowColor: _glowForType(
                                        ItemTypeExt.fromString(
                                            item.itemType)),
                                    onItemChanged: (i) =>
                                        _onItemChanged(catIdx, i),
                                    onItemTapped: (tapped) =>
                                        context.push('/item/${tapped.id}'),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Right: vertical category dots
                      _CategoryDots(
                        pages: pages,
                        currentPage: safePageIdx,
                        glowCtrl: _glowCtrl,
                        onTap: (i) {
                          _pageCtrl.animateToPage(
                            i,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOutCubic,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (e, _) => Center(
            child: Text('Error: $e', style: AppTextStyles.bodyMedium),
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (e, _) => Center(
        child: Text('Error: $e', style: AppTextStyles.bodyMedium),
      ),
    );
  }

  Color _glowForType(ItemType type) => switch (type) {
        ItemType.movie => AppColors.watchColor,
        ItemType.series  => AppColors.seriesColor,
        ItemType.anime => AppColors.animeColor,
        ItemType.game => AppColors.playColor,
        ItemType.product => AppColors.buyColor,
      };
}

// ─── One page = one category ──────────────────────────────────────────────────

class _CategoryPage extends StatelessWidget {
  const _CategoryPage({
    required this.cat,
    required this.catColor,
    required this.items,
    required this.currentIndex,
    required this.wheelController,
    required this.glowCtrl,
    required this.currentItem,
    required this.glowColor,
    required this.onItemChanged,
    this.onItemTapped,
  });

  final Category cat;
  final Color catColor;
  final List<VaultItem> items;
  final int currentIndex;
  final FixedExtentScrollController wheelController;
  final AnimationController glowCtrl;
  final VaultItem currentItem;
  final Color glowColor;
  final ValueChanged<int> onItemChanged;
  final ValueChanged<VaultItem>? onItemTapped;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Category header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
          child: Row(
            children: [
              AnimatedBuilder(
                animation: glowCtrl,
                builder: (_, __) => Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: catColor.withValues(
                        alpha: 0.12 + glowCtrl.value * 0.06),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: catColor.withValues(
                          alpha: 0.35 + glowCtrl.value * 0.2),
                    ),
                  ),
                  child: Icon(
                    CategoryIcons.resolve(cat.iconName),
                    size: 16,
                    color: catColor,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cat.name,
                        style: AppTextStyles.titleSmall
                            .copyWith(color: catColor)),
                    Text(
                      '${items.length} item${items.length == 1 ? '' : 's'}',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              // Swipe hint
              Column(
                children: [
                  Icon(Icons.keyboard_arrow_up_rounded,
                      size: 14, color: AppColors.textMuted),
                  Icon(Icons.keyboard_arrow_down_rounded,
                      size: 14, color: AppColors.textMuted),
                ],
              ),
            ],
          ),
        ),

        // Detail panel for selected item
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _DetailPanel(
              item: currentItem,
              glowColor: glowColor,
              glowCtrl: glowCtrl,
            )
                .animate(key: ValueKey(currentItem.id))
                .fadeIn(duration: 300.ms)
                .slideY(
                    begin: 0.04,
                    end: 0,
                    curve: Curves.easeOutCubic),
          ),
        ),

        const SizedBox(height: 10),

        // Counter
        Text(
          '${currentIndex + 1} / ${items.length}',
          style:
              AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
        ),

        const SizedBox(height: 6),

        // Horizontal cylinder wheel
        Expanded(
          flex: 5,
          child: _VaultCylinderWheel(
            items: items,
            currentIndex: currentIndex,
            controller: wheelController,
            glowCtrl: glowCtrl,
            onItemChanged: onItemChanged,
            onItemTapped: onItemTapped,
          ),
        ),

        const SizedBox(height: 8),
      ],
    );
  }
}

// ─── Custom app bar ───────────────────────────────────────────────────────────

class _WheelAppBar extends ConsumerWidget {
  const _WheelAppBar({required this.glowCtrl});
  final AnimationController glowCtrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.4)),
            ),
            child: const Icon(Icons.video_library_rounded,
                size: 16, color: AppColors.primary),
          ),
          const SizedBox(width: 8),
          Text('QueueVault', style: AppTextStyles.titleMedium),
          const Spacer(),
          GestureDetector(
            onTap: () => showDesignPickerSheet(context),
            child: AnimatedBuilder(
              animation: glowCtrl,
              builder: (_, __) => Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary
                      .withValues(alpha: 0.08 + glowCtrl.value * 0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.primary.withValues(
                        alpha: 0.25 + glowCtrl.value * 0.15),
                  ),
                ),
                child: const Icon(Icons.style_rounded,
                    size: 18, color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Vertical category indicator dots (right rail) ────────────────────────────

class _CategoryDots extends StatelessWidget {
  const _CategoryDots({
    required this.pages,
    required this.currentPage,
    required this.glowCtrl,
    required this.onTap,
  });

  final List<(Category, List<VaultItem>)> pages;
  final int currentPage;
  final AnimationController glowCtrl;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(pages.length, (i) {
          final isActive = i == currentPage;
          final color = _hexToColor(pages[i].$1.colorHex);
          return GestureDetector(
            onTap: () => onTap(i),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: AnimatedBuilder(
                animation: glowCtrl,
                builder: (_, __) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isActive ? 8 : 6,
                  height: isActive ? 24 : 6,
                  decoration: BoxDecoration(
                    color: isActive
                        ? color.withValues(
                            alpha: 0.7 + glowCtrl.value * 0.3)
                        : AppColors.textMuted.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: color.withValues(
                                  alpha: 0.4 + glowCtrl.value * 0.2),
                              blurRadius: 6,
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─── Detail panel for selected item ─────────────────────────────────────────

class _DetailPanel extends ConsumerWidget {
  const _DetailPanel({
    required this.item,
    required this.glowColor,
    required this.glowCtrl,
  });

  final VaultItem item;
  final Color glowColor;
  final AnimationController glowCtrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = ItemTypeExt.fromString(item.itemType);
    final status = ItemStatusExt.fromString(item.status);
    final progress = _calcProgress();
    final posterProvider = itemPosterProvider(item);

    return GestureDetector(
      onTap: () => context.push('/item/${item.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: glowColor.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: glowColor.withValues(alpha: 0.28)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Row(
            children: [
              // Poster
              SizedBox(
                width: 100,
                child: posterProvider != null
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
                                  size: 30, color: AppColors.textMuted),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        color: AppColors.surfaceLight,
                        child: Center(
                          child: Icon(_iconForType(type),
                              size: 30, color: AppColors.textMuted),
                        ),
                      ),
              ),

              // Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CategoryBadge(type: type),
                      const SizedBox(height: 6),
                      Text(
                        item.title,
                        style: AppTextStyles.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item.overview != null) ...[
                        const SizedBox(height: 5),
                        Text(
                          item.overview!,
                          style: AppTextStyles.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const Spacer(),
                      if (progress != null) ...[
                        AnimatedBuilder(
                          animation: glowCtrl,
                          builder: (_, __) => ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: AppColors.surfaceLight,
                              valueColor:
                                  AlwaysStoppedAnimation(glowColor),
                              minHeight: 4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${(progress * 100).round()}% complete',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: glowColor),
                        ),
                      ] else ...[
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: _statusColor(status),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              status.label,
                              style: AppTextStyles.bodySmall.copyWith(
                                  color: _statusColor(status)),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: glowColor.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: glowColor.withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.open_in_new_rounded,
                                size: 12, color: glowColor),
                            const SizedBox(width: 4),
                            Text('Open',
                                style: AppTextStyles.labelSmall.copyWith(
                                    color: glowColor, fontSize: 10)),
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
        item.totalEpisodesAnime != null &&
                item.totalEpisodesAnime! > 0
            ? (item.currentEpisodeAnime ?? 0) / item.totalEpisodesAnime!
            : null,
      ItemType.game => item.completionPercent != null
          ? item.completionPercent! / 100.0
          : null,
      _ => null,
    };
  }

  Color _statusColor(ItemStatus s) => switch (s) {
        ItemStatus.want => AppColors.primary,
        ItemStatus.inProgress => AppColors.accent,
        ItemStatus.completed => AppColors.success,
        ItemStatus.dropped => AppColors.textMuted,
      };

  IconData _iconForType(ItemType type) => switch (type) {
        ItemType.movie => Icons.movie_rounded,
        ItemType.series => Icons.tv_rounded,
        ItemType.anime => Icons.auto_awesome,
        ItemType.game => Icons.sports_esports_rounded,
        ItemType.product => Icons.shopping_bag_rounded,
      };
}

// ─── Horizontal cylinder wheel of items ──────────────────────────────────────

class _VaultCylinderWheel extends StatelessWidget {
  const _VaultCylinderWheel({
    required this.items,
    required this.currentIndex,
    required this.controller,
    required this.glowCtrl,
    required this.onItemChanged,
    this.onItemTapped,
  });

  final List<VaultItem> items;
  final int currentIndex;
  final FixedExtentScrollController controller;
  final AnimationController glowCtrl;
  final ValueChanged<int> onItemChanged;
  final ValueChanged<VaultItem>? onItemTapped;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 136,
        diameterRatio: 2.4,
        perspective: 0.003,
        squeeze: 0.88,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onItemChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: items.length,
          builder: (context, i) {
            final item = items[i];
            final isCentered = i == currentIndex;
            final type = ItemTypeExt.fromString(item.itemType);
            final glowColor = _glowForType(type);
            return RotatedBox(
              quarterTurns: -1,
              child: AnimatedBuilder(
                animation: glowCtrl,
                builder: (_, __) => _WheelItemCard(
                  item: item,
                  isCentered: isCentered,
                  glowColor: glowColor,
                  glowPulse: isCentered ? glowCtrl.value : 0.0,
                  onTap: isCentered ? () => onItemTapped?.call(item) : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Color _glowForType(ItemType type) => switch (type) {
        ItemType.movie => AppColors.watchColor,
        ItemType.series  => AppColors.seriesColor,
        ItemType.anime => AppColors.animeColor,
        ItemType.game => AppColors.playColor,
        ItemType.product => AppColors.buyColor,
      };
}

// ─── Individual wheel card ────────────────────────────────────────────────────

class _WheelItemCard extends StatefulWidget {
  const _WheelItemCard({
    required this.item,
    required this.isCentered,
    required this.glowColor,
    required this.glowPulse,
    this.onTap,
  });

  final VaultItem item;
  final bool isCentered;
  final Color glowColor;
  final double glowPulse;
  final VoidCallback? onTap;

  @override
  State<_WheelItemCard> createState() => _WheelItemCardState();
}

class _WheelItemCardState extends State<_WheelItemCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
    reverseDuration: const Duration(milliseconds: 200),
    lowerBound: 0.0,
    upperBound: 0.06,
  );

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final type = ItemTypeExt.fromString(item.itemType);
    final posterProvider = itemPosterProvider(item);
    return GestureDetector(
      onTapDown: widget.isCentered && widget.onTap != null
          ? (_) => _pressCtrl.forward()
          : null,
      onTapUp: widget.isCentered && widget.onTap != null
          ? (_) {
              _pressCtrl.reverse();
              widget.onTap!();
            }
          : null,
      onTapCancel: widget.isCentered && widget.onTap != null
          ? () => _pressCtrl.reverse()
          : null,
      child: AnimatedBuilder(
        animation: _pressCtrl,
        builder: (_, child) => Transform.scale(
          scale: 1.0 - _pressCtrl.value,
          child: child,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          margin: EdgeInsets.symmetric(
            horizontal: widget.isCentered ? 4 : 10,
            vertical: widget.isCentered ? 4 : 14,
          ),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: widget.isCentered
                  ? widget.glowColor.withValues(alpha: 0.7)
                  : AppColors.cardBorder,
              width: widget.isCentered ? 1.5 : 1,
            ),
            boxShadow: widget.isCentered
                ? [
                    BoxShadow(
                      color: widget.glowColor
                          .withValues(alpha: 0.28 + widget.glowPulse * 0.16),
                      blurRadius: 16 + widget.glowPulse * 10,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: posterProvider != null
                ? Image(
                    image: posterProvider,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.surfaceLight,
                      child: Center(
                        child: Icon(
                          _iconForType(type),
                          size: widget.isCentered ? 30 : 22,
                          color: widget.isCentered
                              ? widget.glowColor
                              : AppColors.textMuted,
                        ),
                      ),
                    ),
                  )
                : Container(
                    color: AppColors.surfaceLight,
                    child: Center(
                      child: Icon(
                        _iconForType(type),
                        size: widget.isCentered ? 30 : 22,
                        color: widget.isCentered
                            ? widget.glowColor
                            : AppColors.textMuted,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  IconData _iconForType(ItemType type) => switch (type) {
        ItemType.movie => Icons.movie_rounded,
        ItemType.series => Icons.tv_rounded,
        ItemType.anime => Icons.auto_awesome,
        ItemType.game => Icons.sports_esports_rounded,
        ItemType.product => Icons.shopping_bag_rounded,
      };
}

// ─── Empty state ─────────────────────────────────────────────────────────────

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

// ─── Helpers ─────────────────────────────────────────────────────────────────

Color _hexToColor(String hex) {
  final clean = hex.replaceAll('#', '');
  return Color(int.parse(clean.length == 6 ? 'FF$clean' : clean, radix: 16));
}
