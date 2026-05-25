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
import '../../../core/widgets/category_badge.dart';
import '../../../core/widgets/glass_card.dart';
import '../../vault/data/models/item_type.dart';
import '../../vault/domain/vault_providers.dart';

class DiscoverDetailScreen extends ConsumerStatefulWidget {
  const DiscoverDetailScreen({super.key, required this.result});
  final SearchResult result;

  @override
  ConsumerState<DiscoverDetailScreen> createState() =>
      _DiscoverDetailScreenState();
}

class _DiscoverDetailScreenState extends ConsumerState<DiscoverDetailScreen> {
  bool _adding = false;
  bool _added = false;

  Color get _typeColor => switch (widget.result.type) {
        ItemType.movie   => AppColors.watchColor,
        ItemType.series  => AppColors.seriesColor,
        ItemType.anime   => AppColors.animeColor,
        ItemType.game    => AppColors.playColor,
        ItemType.product => AppColors.buyColor,
      };

  Future<void> _addToVault() async {
    if (_added || _adding) return;
    HapticFeedback.mediumImpact();
    setState(() => _adding = true);

    final r = widget.result;
    final repo = ref.read(vaultRepositoryProvider);

    await repo.add(VaultItemsCompanion.insert(
      itemType:  r.type.value,
      title:     r.title,
      posterUrl: Value(r.posterUrl),
      backdropUrl: Value(r.backdropUrl),
      overview:  Value(r.overview),
      externalId: Value(r.id),
      releaseYear: Value(r.year),
      genre: Value(r.genre),
      // anime extras
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
      // game extras
      metacriticScore: Value(r.extraData['metacritic'] as int?),
      estimatedPlaytimeHours: Value(r.extraData['playtime'] as int?),
      platform: Value(r.extraData['platforms'] as String?),
      // product extras
      targetPrice: Value(
        r.extraData['price'] != null
            ? (r.extraData['price'] as num).toDouble()
            : null,
      ),
      storeUrl: Value(r.extraData['store_url'] as String?),
    ));

    if (mounted) {
      HapticFeedback.heavyImpact();
      setState(() {
        _adding = false;
        _added  = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.result;
    final type = r.type;
    final hasBackdrop = r.backdropUrl?.isNotEmpty == true;
    final hasPoster   = r.posterUrl?.isNotEmpty == true;

    return Scaffold(
      backgroundColor: AppColors.background,
      // ── Floating Add button pinned at bottom ──────────────────────────────
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: _AddButton(
            added:  _added,
            adding: _adding,
            color:  _typeColor,
            label:  _labelForType(type),
            onTap:  _addToVault,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // ── Hero image app bar ───────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: GlassCard(
                borderRadius: 50,
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.arrow_back_ios_rounded,
                    color: Colors.white, size: 20),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Backdrop or poster
                  if (hasBackdrop)
                    CachedNetworkImage(
                      imageUrl: r.backdropUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(color: AppColors.surfaceLight),
                      errorWidget: (_, __, ___) =>
                          Container(color: AppColors.surfaceLight),
                    )
                  else if (hasPoster)
                    CachedNetworkImage(
                      imageUrl: r.posterUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(color: AppColors.surfaceLight),
                      errorWidget: (_, __, ___) =>
                          Container(color: AppColors.surfaceLight),
                    )
                  else
                    Container(
                      color: AppColors.surfaceLight,
                      child: Icon(_iconForType(type),
                          size: 80, color: AppColors.textMuted),
                    ),
                  // Gradient fade to background
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.background.withValues(alpha: 0.6),
                          AppColors.background,
                        ],
                        stops: const [0.4, 0.75, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Detail content ───────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge
                  CategoryBadge(type: type),
                  const SizedBox(height: 10),

                  // Title
                  Text(r.title, style: AppTextStyles.displayMedium),

                  // Meta row
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    children: [
                      if (r.year != null)
                        _MetaChip(Icons.calendar_today_outlined,
                            '${r.year}', _typeColor),
                      if (r.genre != null)
                        _MetaChip(Icons.label_outline, r.genre!, _typeColor),
                      if (r.extraData['format'] != null)
                        _MetaChip(Icons.format_list_bulleted_outlined,
                            r.extraData['format'] as String, _typeColor),
                      if (r.extraData['metacritic'] != null)
                        _MetaChip(Icons.star_outline,
                            'Metacritic ${r.extraData['metacritic']}',
                            AppColors.warning),
                      if (r.extraData['price'] != null)
                        _MetaChip(Icons.attach_money,
                            '\$${(r.extraData['price'] as num).toStringAsFixed(2)}',
                            AppColors.buyColor),
                    ],
                  ),

                  // Poster thumbnail (if backdrop shown above)
                  if (hasBackdrop && hasPoster) ...[
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: r.posterUrl!,
                        width: 80,
                        height: 114,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            Container(color: AppColors.surfaceLight),
                      ),
                    ),
                  ],

                  // Overview
                  if (r.overview?.isNotEmpty == true) ...[
                    const SizedBox(height: 16),
                    Text('Overview', style: AppTextStyles.titleSmall),
                    const SizedBox(height: 6),
                    Text(
                      r.overview!,
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ],

                  // "Go to Vault" shortcut appears after adding
                  if (_added) ...[
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        // Signal the vault to jump to this category
                        ref.read(vaultJumpToTypeProvider.notifier).state =
                            widget.result.type.value;
                        context.go('/vault');
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Text(
                          'Go to Vault →',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.titleSmall
                              .copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1),
                  ],
                ],
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0),
            ),
          ),
        ],
      ),
    );
  }


  String _labelForType(ItemType t) => switch (t) {
        ItemType.movie   => 'Movie',
        ItemType.series  => 'Series',
        ItemType.anime   => 'Anime',
        ItemType.game    => 'Game',
        ItemType.product => 'Product',
      };

  IconData _iconForType(ItemType t) => switch (t) {
        ItemType.movie   => Icons.movie_rounded,
        ItemType.series  => Icons.tv_rounded,
        ItemType.anime   => Icons.auto_awesome,
        ItemType.game    => Icons.sports_esports_rounded,
        ItemType.product => Icons.shopping_bag_rounded,
      };
}

// ─── Add button ───────────────────────────────────────────────────────────────

class _AddButton extends StatelessWidget {
  const _AddButton({
    required this.added,
    required this.adding,
    required this.color,
    required this.label,
    required this.onTap,
  });

  final bool added;
  final bool adding;
  final Color color;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: added
              ? AppColors.success.withValues(alpha: 0.15)
              : color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: added
                ? AppColors.success.withValues(alpha: 0.5)
                : color.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (adding)
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: color,
                ),
              )
            else
              Icon(
                added ? Icons.check_circle_rounded : Icons.add_circle_outline,
                color: added ? AppColors.success : color,
                size: 22,
              ),
            const SizedBox(width: 10),
            Text(
              added
                  ? 'Added to Vault!'
                  : adding
                      ? 'Adding…'
                      : 'Add $label to Vault',
              style: AppTextStyles.titleSmall.copyWith(
                color: added ? AppColors.success : color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Meta chip ────────────────────────────────────────────────────────────────

class _MetaChip extends StatelessWidget {
  const _MetaChip(this.icon, this.label, this.color);
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: AppTextStyles.labelSmall.copyWith(
                  color: color, fontSize: 11)),
        ],
      ),
    );
  }
}
