import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/item_images.dart';
import '../../../core/database/app_database.dart';
import '../data/models/item_type.dart';
import '../domain/layout_preferences_provider.dart';

// Compact card used in horizontal swimlane rows.
// [featured] = taller card for "Continue Watching" row.
class VaultItemMiniCard extends ConsumerWidget {
  const VaultItemMiniCard({
    super.key,
    required this.item,
    required this.index,
    this.featured = false,
  });

  final VaultItem item;
  final int index;
  final bool featured;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(layoutPrefsProvider);
    final type = ItemTypeExt.fromString(item.itemType);
    final glowColor = _glowForType(type);
    final posterProvider = itemPosterProvider(item);
    final w = featured ? 160.0 : 120.0;
    final h = featured ? 240.0 : 175.0;

    Widget card = GestureDetector(
      onTap: () => context.push('/item/${item.id}'),
      child: Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: glowColor.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: glowColor.withValues(alpha: 0.18),
              blurRadius: 14,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _MiniPoster(
                  image: posterProvider,
                  type: type,
                  heroTag: prefs.heroTransitions
                      ? 'vault_poster_${item.id}'
                      : null,
                  enableParallax: prefs.parallaxPosters,
                ),
              ),
              _MiniInfo(item: item, featured: featured),
            ],
          ),
        ),
      ),
    );

    return card
        .animate(delay: Duration(milliseconds: index * 60))
        .fadeIn(duration: 280.ms)
        .slideX(begin: 0.12, end: 0, curve: Curves.easeOutCubic);
  }

  Color _glowForType(ItemType type) => switch (type) {
        ItemType.movie => AppColors.watchGlow,
        ItemType.series => AppColors.watchGlow,
        ItemType.anime => AppColors.animeGlow,
        ItemType.game => AppColors.playGlow,
        ItemType.product => AppColors.buyGlow,
      };
}

class _MiniPoster extends StatefulWidget {
  const _MiniPoster({
    required this.image,
    required this.type,
    this.heroTag,
    this.enableParallax = false,
  });

  final ImageProvider? image;
  final ItemType type;
  final String? heroTag;
  final bool enableParallax;

  @override
  State<_MiniPoster> createState() => _MiniPosterState();
}

class _MiniPosterState extends State<_MiniPoster> {
  final _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Widget image;

    if (widget.image != null) {
      if (widget.enableParallax) {
        final scrollable = Scrollable.maybeOf(context);
        if (scrollable != null) {
          image = AnimatedBuilder(
            animation: scrollable.position,
            builder: (ctx, _) {
              double offset = 0;
              final box =
                  _key.currentContext?.findRenderObject() as RenderBox?;
              final scrollBox =
                  scrollable.context.findRenderObject() as RenderBox?;
              if (box != null && scrollBox != null && box.attached) {
                final pos =
                    box.localToGlobal(Offset.zero, ancestor: scrollBox);
                final viewport = scrollable.position.viewportDimension;
                final fraction = (pos.dx / viewport).clamp(0.0, 1.0);
                offset = (fraction - 0.5) * 24.0;
              }
              return ClipRect(
                child: OverflowBox(
                  maxWidth: double.infinity,
                  child: Transform.translate(
                    offset: Offset(offset, 0),
                    child: Image(
                      image: widget.image!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (_, __, ___) =>
                          Container(color: AppColors.surfaceLight),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          image = Image(
            image: widget.image!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (_, __, ___) =>
                Container(color: AppColors.surfaceLight),
          );
        }
      } else {
        image = Image(
          image: widget.image!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (_, __, ___) =>
              Container(color: AppColors.surfaceLight),
        );
      }
    } else {
      image = Container(
        color: AppColors.surfaceLight,
        child: Center(
          child: Icon(_iconForType(widget.type),
              size: 28, color: AppColors.textMuted),
        ),
      );
    }

    if (widget.heroTag != null && widget.image != null) {
      return Hero(
        key: _key,
        tag: widget.heroTag!,
        child: SizedBox.expand(child: image),
      );
    }
    return SizedBox(key: _key, child: image);
  }

  IconData _iconForType(ItemType type) => switch (type) {
        ItemType.movie => Icons.movie_rounded,
        ItemType.series => Icons.tv_rounded,
        ItemType.anime => Icons.auto_awesome,
        ItemType.game => Icons.sports_esports_rounded,
        ItemType.product => Icons.shopping_bag_rounded,
      };
}

class _MiniInfo extends StatelessWidget {
  const _MiniInfo({required this.item, required this.featured});

  final VaultItem item;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    final status = ItemStatusExt.fromString(item.status);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.title,
            style: AppTextStyles.titleSmall.copyWith(fontSize: 11),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (featured && status == ItemStatus.inProgress) ...[
            const SizedBox(height: 5),
            _ProgressBar(item: item),
          ] else ...[
            const SizedBox(height: 3),
            _StatusDot(status: status),
          ],
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.item});
  final VaultItem item;

  @override
  Widget build(BuildContext context) {
    final type = ItemTypeExt.fromString(item.itemType);
    final progress = switch (type) {
      ItemType.series => item.totalEpisodes != null && item.totalEpisodes! > 0
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

    if (progress == null) {
      return Text(
        'In Progress',
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.accent,
          fontSize: 9,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.surfaceLight,
            valueColor: const AlwaysStoppedAnimation(AppColors.accent),
            minHeight: 2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${(progress * 100).round()}%',
          style: AppTextStyles.bodySmall
              .copyWith(color: AppColors.accent, fontSize: 9),
        ),
      ],
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.status});
  final ItemStatus status;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            color: _color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          status.label,
          style: AppTextStyles.bodySmall.copyWith(fontSize: 9),
        ),
      ],
    );
  }

  Color get _color => switch (status) {
        ItemStatus.want => AppColors.primary,
        ItemStatus.inProgress => AppColors.accent,
        ItemStatus.completed => AppColors.success,
        ItemStatus.dropped => AppColors.textMuted,
      };
}
