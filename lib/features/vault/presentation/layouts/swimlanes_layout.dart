import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/utils/category_icons.dart';
import '../../data/models/item_type.dart';
import '../../domain/vault_providers.dart';
import '../vault_item_mini_card.dart';
import '../widgets/vault_app_bar.dart';

class SwimlanesLayout extends ConsumerWidget {
  const SwimlanesLayout({super.key});

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
              data: (cats) => _SwimlaneSlivers(items: items, categories: cats),
              loading: () => const SliverToBoxAdapter(
                  child: SizedBox(height: 200,
                      child: Center(child: CircularProgressIndicator(color: AppColors.primary)))),
              error: (_, __) => const SliverToBoxAdapter(child: SizedBox()),
            );
          },
          loading: () => const SliverToBoxAdapter(
              child: SizedBox(height: 200,
                  child: Center(child: CircularProgressIndicator(color: AppColors.primary)))),
          error: (e, _) => SliverFillRemaining(
            child: Center(child: Text('Error: $e', style: AppTextStyles.bodyMedium)),
          ),
        ),
      ],
    );
  }

}

class _SwimlaneSlivers extends StatelessWidget {
  const _SwimlaneSlivers({required this.items, required this.categories});

  final List<VaultItem> items;
  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    final inProgress = items
        .where((i) => i.status == ItemStatus.inProgress.value)
        .toList();

    // Build category rows — only categories that have items
    final catRows = <(Category, List<VaultItem>)>[];
    for (final cat in categories) {
      final catItems = items.where((i) => i.itemType == cat.typeKey).toList();
      if (catItems.isNotEmpty) catRows.add((cat, catItems));
    }

    return SliverList(
      delegate: SliverChildListDelegate([
        if (inProgress.isNotEmpty) ...[
          _SwimlaneRow(
            title: 'Continue Watching',
            icon: Icons.play_circle_outline_rounded,
            iconColor: AppColors.accent,
            items: inProgress,
            featured: true,
          ),
        ],
        ...catRows.map((entry) {
          final (cat, catItems) = entry;
          final color = _hexToColor(cat.colorHex);
          return _SwimlaneRow(
            title: cat.name,
            icon: CategoryIcons.resolve(cat.iconName),
            iconColor: color,
            items: catItems,
            featured: false,
          );
        }),
        const SizedBox(height: 100),
      ]),
    );
  }
}

class _SwimlaneRow extends StatelessWidget {
  const _SwimlaneRow({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.items,
    required this.featured,
  });

  final String title;
  final IconData icon;
  final Color iconColor;
  final List<VaultItem> items;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    final rowHeight = featured ? 268.0 : 210.0;

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(icon, size: 16, color: iconColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(color: iconColor),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${items.length}',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: iconColor,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Horizontal scroll
          SizedBox(
            height: rowHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, i) => VaultItemMiniCard(
                item: items[i],
                index: i,
                featured: featured,
              ),
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
