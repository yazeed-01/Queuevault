import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/category_icons.dart';
import '../../../core/utils/item_images.dart';
import '../data/models/item_type.dart';
import '../domain/layout_preferences_provider.dart';
import '../domain/vault_providers.dart';
import 'layouts/deck_spotlight_layout.dart';
import 'layouts/hero_feed_layout.dart';
import 'layouts/swimlanes_layout.dart';
import 'layouts/wheel_browser_layout.dart';
import 'vault_item_card.dart';
import 'widgets/vault_app_bar.dart';

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.shimmerBase,
        borderRadius: BorderRadius.circular(14),
      ),
    ).animate(onPlay: (c) => c.repeat()).shimmer(
          duration: 1200.ms,
          color: AppColors.shimmerHighlight,
        );
  }
}

class VaultScreen extends ConsumerWidget {
  const VaultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(layoutPrefsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: switch (prefs.layout) {
        VaultLayout.swimlanes => const SwimlanesLayout(),
        VaultLayout.heroFeed => const HeroFeedLayout(),
        VaultLayout.deckSpotlight => const DeckSpotlightLayout(),
        VaultLayout.wheelBrowser => const WheelBrowserLayout(),
        VaultLayout.grid => _GridBody(prefs: prefs),
      },
      floatingActionButton: _AddFab(),
    );
  }
}

// ─── Classic grid body (original layout + staggered option) ──────────────────

class _GridBody extends ConsumerWidget {
  const _GridBody({required this.prefs});
  final LayoutPrefs prefs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(vaultStreamProvider);
    final selectedFilter = ref.watch(selectedFilterProvider);
    final categoriesAsync = ref.watch(categoriesStreamProvider);

    return CustomScrollView(
      slivers: [
        const VaultSliverAppBar(),
        SliverToBoxAdapter(
          child: categoriesAsync.when(
            data: (cats) => _FilterBar(
              categories: cats,
              selected: selectedFilter,
              onSelect: (key) =>
                  ref.read(selectedFilterProvider.notifier).state = key,
            ),
            loading: () => const SizedBox(height: 48),
            error: (_, __) => const SizedBox(height: 48),
          ),
        ),
        itemsAsync.when(
          data: (items) => items.isEmpty
              ? SliverFillRemaining(
                  child: _EmptyState(filterKey: selectedFilter))
              : prefs.staggeredGrid
                  ? _StaggeredGridSliver(items: items)
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.62,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, i) =>
                              VaultItemCard(item: items[i], index: i),
                          childCount: items.length,
                        ),
                      ),
                    ),
          loading: () => SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.62,
              ),
              delegate: SliverChildBuilderDelegate(
                (_, __) => const _ShimmerCard(),
                childCount: 6,
              ),
            ),
          ),
          error: (e, _) => SliverFillRemaining(
            child: Center(
              child: Text('Error: $e', style: AppTextStyles.bodyMedium),
            ),
          ),
        ),
      ],
    );
  }

}

// ─── Staggered (masonry) grid sliver ─────────────────────────────────────────

class _StaggeredGridSliver extends StatelessWidget {
  const _StaggeredGridSliver({required this.items});
  final List<VaultItem> items;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childCount: items.length,
        itemBuilder: (context, i) {
            final hasPoster = itemPosterProvider(items[i]) != null;
          return SizedBox(
            height: hasPoster ? 260 : 160,
            child: VaultItemCard(item: items[i], index: i),
          );
        },
      ),
    );
  }
}

// ─── Filter bar ──────────────────────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.categories,
    required this.selected,
    required this.onSelect,
  });

  final List<Category> categories;
  final String? selected;
  final void Function(String?) onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          if (i == 0) {
            final isSelected = selected == null;
            return FilterChip(
              selected: isSelected,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.grid_view_rounded,
                      size: 14,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textMuted),
                  const SizedBox(width: 6),
                  Text('All',
                      style: AppTextStyles.labelSmall.copyWith(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textMuted)),
                ],
              ),
              onSelected: (_) => onSelect(null),
              backgroundColor: AppColors.surfaceLight,
              selectedColor: AppColors.primary.withValues(alpha: 0.15),
              side: BorderSide(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.5)
                      : AppColors.cardBorder),
              showCheckmark: false,
            );
          }
          final cat = categories[i - 1];
          final color = _hexToColor(cat.colorHex);
          final isSelected = selected == cat.typeKey;
          return FilterChip(
            selected: isSelected,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(CategoryIcons.resolve(cat.iconName),
                    size: 14,
                    color: isSelected ? color : AppColors.textMuted),
                const SizedBox(width: 6),
                Text(cat.name,
                    style: AppTextStyles.labelSmall.copyWith(
                        color:
                            isSelected ? color : AppColors.textMuted)),
              ],
            ),
            onSelected: (_) => onSelect(cat.typeKey),
            backgroundColor: AppColors.surfaceLight,
            selectedColor: color.withValues(alpha: 0.15),
            side: BorderSide(
                color: isSelected
                    ? color.withValues(alpha: 0.5)
                    : AppColors.cardBorder),
            showCheckmark: false,
          );
        },
      ),
    );
  }
}

Color _hexToColor(String hex) {
  final clean = hex.replaceAll('#', '');
  return Color(int.parse(clean.length == 6 ? 'FF$clean' : clean, radix: 16));
}

// ─── FAB ─────────────────────────────────────────────────────────────────────

class _AddFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'fab_main',
      backgroundColor: AppColors.primary,
      onPressed: () {
        HapticFeedback.mediumImpact();
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const _QuickAddSheet(),
        );
      },
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}

// ─── Quick add sheet ─────────────────────────────────────────────────────────

class _QuickAddSheet extends ConsumerStatefulWidget {
  const _QuickAddSheet();

  @override
  ConsumerState<_QuickAddSheet> createState() => _QuickAddSheetState();
}

class _QuickAddSheetState extends ConsumerState<_QuickAddSheet> {
  final _ctrl = TextEditingController();
  Category? _selectedCategory;
  ItemStatus _status = ItemStatus.want;
  bool _saving = false;

  Color get _categoryColor {
    if (_selectedCategory == null) return AppColors.primary;
    return _hexToColor(_selectedCategory!.colorHex);
  }

  Future<void> _save() async {
    final title = _ctrl.text.trim();
    final cat = _selectedCategory;
    if (title.isEmpty || cat == null) return;
    setState(() => _saving = true);
    HapticFeedback.mediumImpact();
    await ref.read(vaultRepositoryProvider).add(VaultItemsCompanion.insert(
          itemType: cat.typeKey,
          title: title,
          status: Value(_status.value),
        ));
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final categoriesAsync = ref.watch(categoriesStreamProvider);

    return categoriesAsync.when(
      loading: () => const SizedBox(
          height: 200,
          child: Center(
              child: CircularProgressIndicator(color: AppColors.primary))),
      error: (_, __) => const SizedBox(height: 200),
      data: (cats) {
        if (_selectedCategory == null && cats.isNotEmpty) {
          _selectedCategory = cats.first;
        }
        final color = _categoryColor;

        return Container(
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottom),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.cardBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.bolt, color: color, size: 16),
                  const SizedBox(width: 6),
                  Text('Quick Add', style: AppTextStyles.titleSmall.copyWith(color: color)),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _ctrl,
                autofocus: true,
                style: AppTextStyles.titleMedium
                    .copyWith(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'What do you want to ${_statusVerb()}?',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onSubmitted: (_) => _save(),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 34,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: cats.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final cat = cats[i];
                    final sel =
                        _selectedCategory?.typeKey == cat.typeKey;
                    final c = _hexToColor(cat.colorHex);
                    final chipColor =
                        sel ? c : AppColors.textMuted;
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _selectedCategory = cat);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: sel
                              ? c.withValues(alpha: 0.15)
                              : AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: sel
                                ? c.withValues(alpha: 0.5)
                                : AppColors.cardBorder,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(CategoryIcons.resolve(cat.iconName),
                                size: 13, color: chipColor),
                            const SizedBox(width: 5),
                            Text(cat.name,
                                style: AppTextStyles.labelSmall.copyWith(
                                    color: chipColor, fontSize: 12)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: ItemStatus.values.map((s) {
                  final sel = _status == s;
                  final sc = _statusColor(s);
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _status = s);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        margin: const EdgeInsets.only(right: 6),
                        padding:
                            const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: sel
                              ? sc.withValues(alpha: 0.15)
                              : AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: sel
                                ? sc.withValues(alpha: 0.5)
                                : AppColors.cardBorder,
                          ),
                        ),
                        child: Text(s.label,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: sel ? sc : AppColors.textMuted,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        final query = _ctrl.text.trim();
                        Navigator.of(context).pop();
                        context.push('/add', extra: {
                          'type': _selectedCategory?.typeKey ?? 'movie',
                          if (query.isNotEmpty) 'query': query,
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: color.withValues(alpha: 0.4)),
                        foregroundColor: color,
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.search, size: 16),
                      label: const Text('Search'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _saving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black),
                            )
                          : Text('Add to Vault',
                              style: AppTextStyles.titleSmall
                                  .copyWith(color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _statusVerb() => switch (_status) {
        ItemStatus.want => 'add',
        ItemStatus.inProgress => 'track',
        ItemStatus.completed => 'remember',
        ItemStatus.dropped => 'log',
      };

  Color _statusColor(ItemStatus s) => switch (s) {
        ItemStatus.want => AppColors.primary,
        ItemStatus.inProgress => AppColors.accent,
        ItemStatus.completed => AppColors.success,
        ItemStatus.dropped => AppColors.textMuted,
      };
}

// ─── Empty state ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({this.filterKey});
  final String? filterKey;

  @override
  Widget build(BuildContext context) {
    final label = filterKey == null
        ? 'Your vault is empty'
        : 'Nothing in this category yet';
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.video_library_outlined,
              size: 64, color: AppColors.textMuted),
          const SizedBox(height: 16),
          Text(label, style: AppTextStyles.titleMedium),
          const SizedBox(height: 8),
          Text('Tap + to quick-add', style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}
