import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/database/app_database.dart';
import '../../../core/network/search_result.dart';
import '../../../core/widgets/glow_card.dart';
import '../../../core/widgets/category_badge.dart';
import '../../vault/data/models/item_type.dart';
import '../data/recommendations_repository.dart';

class RecommendationsScreen extends ConsumerWidget {
  const RecommendationsScreen({super.key, required this.item});
  final VaultItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiRecs = ref.watch(recommendationsProvider(item));
    final vaultRecs = ref.watch(vaultRecsProvider(item));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('More Like This', style: AppTextStyles.titleLarge),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        children: [
          // From vault
          vaultRecs.when(
            data: (items) => items.isEmpty
                ? const SizedBox.shrink()
                : _Section(
                    title: 'From Your Vault',
                    subtitle: 'Similar items you already tracked',
                    child: SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: items.length,
                        itemBuilder: (_, i) => _VaultRecCard(item: items[i], index: i),
                      ),
                    ),
                  ),
            loading: () => _ShimmerRow(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 24),
          // From API
          apiRecs.when(
            data: (list) => list.isEmpty
                ? _EmptyApiRecs(item: item)
                : _Section(
                    title: 'Because You Like "${item.title}"',
                    subtitle: 'Recommended by ${_apiName(item)}',
                    child: SizedBox(
                      height: 260,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: list.length,
                        itemBuilder: (_, i) => _ApiRecCard(result: list[i], index: i),
                      ),
                    ),
                  ),
            loading: () => _ShimmerRow(),
            error: (_, __) => _EmptyApiRecs(item: item),
          ),
        ],
      ),
    );
  }

  String _apiName(VaultItem item) {
    return switch (ItemTypeExt.fromString(item.itemType)) {
      ItemType.movie || ItemType.series => 'TMDB',
      ItemType.anime => 'AniList',
      ItemType.game => 'RAWG',
      ItemType.product => '',
    };
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.subtitle, required this.child});
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.titleMedium),
        const SizedBox(height: 4),
        Text(subtitle, style: AppTextStyles.bodySmall),
        const SizedBox(height: 14),
        child,
      ],
    );
  }
}

class _ApiRecCard extends StatelessWidget {
  const _ApiRecCard({required this.result, required this.index});
  final SearchResult result;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GlowCard(
        glowIntensity: 0.5,
        borderRadius: 14,
        onTap: () => context.push('/add', extra: {'type': result.type.name}),
        child: SizedBox(
          width: 140,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
                  child: result.posterUrl != null
                      ? CachedNetworkImage(
                          imageUrl: result.posterUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (_, __) => _placeholder,
                          errorWidget: (_, __, ___) => _placeholder,
                        )
                      : _placeholder,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(result.title,
                        style: AppTextStyles.titleSmall.copyWith(fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    if (result.year != null) ...[
                      const SizedBox(height: 2),
                      Text('${result.year}', style: AppTextStyles.bodySmall),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      )
          .animate(delay: Duration(milliseconds: index * 50))
          .fadeIn(duration: 300.ms)
          .slideX(begin: 0.1, end: 0),
    );
  }

  Widget get _placeholder => Container(
        color: AppColors.surfaceLight,
        child: const Icon(Icons.image_not_supported, color: AppColors.textMuted),
      );
}

class _VaultRecCard extends StatelessWidget {
  const _VaultRecCard({required this.item, required this.index});
  final VaultItem item;
  final int index;

  @override
  Widget build(BuildContext context) {
    final type = ItemTypeExt.fromString(item.itemType);
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GlowCard(
        glowIntensity: 0.6,
        borderRadius: 14,
        onTap: () => context.push('/item/${item.id}'),
        child: SizedBox(
          width: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
                  child: item.posterUrl != null
                      ? CachedNetworkImage(
                          imageUrl: item.posterUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (_, __) => Container(color: AppColors.surfaceLight),
                          errorWidget: (_, __, ___) => Container(color: AppColors.surfaceLight),
                        )
                      : Container(color: AppColors.surfaceLight),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CategoryBadge(type: type, small: true),
                    const SizedBox(height: 4),
                    Text(item.title,
                        style: AppTextStyles.titleSmall.copyWith(fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
          .animate(delay: Duration(milliseconds: index * 50))
          .fadeIn(duration: 300.ms)
          .slideX(begin: 0.1, end: 0),
    );
  }
}

class _EmptyApiRecs extends StatelessWidget {
  const _EmptyApiRecs({required this.item});
  final VaultItem item;

  @override
  Widget build(BuildContext context) {
    final type = ItemTypeExt.fromString(item.itemType);
    final isProduct = type == ItemType.product;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Icon(Icons.explore_outlined, size: 40, color: AppColors.textMuted),
          const SizedBox(height: 10),
          Text(
            isProduct ? 'No recommendations for products' : 'Add API key in Settings to get recommendations',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ShimmerRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (_, i) => Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Container(
            width: 140,
            decoration: BoxDecoration(
              color: AppColors.shimmerBase,
              borderRadius: BorderRadius.circular(14),
            ),
          )
              .animate(onPlay: (c) => c.repeat())
              .shimmer(duration: 1200.ms, color: AppColors.shimmerHighlight),
        ),
      ),
    );
  }
}
