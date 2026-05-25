import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/item_images.dart';
import '../../../core/widgets/category_badge.dart';
import '../../../core/widgets/glow_card.dart';
import '../../../core/database/app_database.dart';
import '../data/models/item_type.dart';
import '../domain/layout_preferences_provider.dart';

class VaultItemCard extends ConsumerStatefulWidget {
  const VaultItemCard({super.key, required this.item, required this.index});

  final VaultItem item;
  final int index;

  @override
  ConsumerState<VaultItemCard> createState() => _VaultItemCardState();
}

class _VaultItemCardState extends ConsumerState<VaultItemCard> {
  bool _flipped = false;

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(layoutPrefsProvider);
    final type = ItemTypeExt.fromString(widget.item.itemType);
    final glowColor = _glowForType(type);
    final posterProvider = itemPosterProvider(widget.item);

    Widget front = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _Poster(
            image: posterProvider,
            type: type,
            heroTag: prefs.heroTransitions
                ? 'vault_poster_${widget.item.id}'
                : null,
            enableParallax: prefs.parallaxPosters,
          ),
        ),
        _Info(item: widget.item, type: type),
      ],
    );

    Widget cardChild = prefs.cardFlip
        ? _CardFlipper(
            flipped: _flipped,
            front: front,
            back: _CardBack(item: widget.item, type: type),
          )
        : front;

    Widget card = GlowCard(
      glowColor: glowColor,
      borderColor: glowColor.withValues(alpha: 0.3),
      borderRadius: 16,
      onTap: () {
        if (prefs.cardFlip && _flipped) {
          setState(() => _flipped = false);
          return;
        }
        context.push('/item/${widget.item.id}');
      },
      child: cardChild,
    );

    if (prefs.cardFlip) {
      card = GestureDetector(
        onLongPress: () {
          HapticFeedback.mediumImpact();
          setState(() => _flipped = !_flipped);
        },
        child: card,
      );
    }

    if (prefs.scrollReveal) {
      return card
          .animate()
          .fadeIn(duration: 350.ms, curve: Curves.easeOut)
          .slideY(begin: 0.1, end: 0, duration: 350.ms, curve: Curves.easeOutCubic);
    }

    return card
        .animate(delay: Duration(milliseconds: (widget.index * 50).clamp(0, 400)))
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic);
  }

  Color _glowForType(ItemType type) => switch (type) {
        ItemType.movie => AppColors.watchGlow,
        ItemType.series  => AppColors.seriesGlow,
        ItemType.anime => AppColors.animeGlow,
        ItemType.game => AppColors.playGlow,
        ItemType.product => AppColors.buyGlow,
      };
}

// ─── Card flip wrapper ───────────────────────────────────────────────────────

class _CardFlipper extends StatelessWidget {
  const _CardFlipper({
    required this.flipped,
    required this.front,
    required this.back,
  });

  final bool flipped;
  final Widget front;
  final Widget back;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: flipped ? pi : 0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      builder: (_, angle, __) {
        final showFront = angle < pi / 2;
        return Transform(
          transform: Matrix4.rotationY(angle),
          alignment: Alignment.center,
          child: showFront
              ? front
              : Transform(
                  transform: Matrix4.rotationY(pi),
                  alignment: Alignment.center,
                  child: back,
                ),
        );
      },
    );
  }
}

// ─── Card back face ──────────────────────────────────────────────────────────

class _CardBack extends StatelessWidget {
  const _CardBack({required this.item, required this.type});

  final VaultItem item;
  final ItemType type;

  @override
  Widget build(BuildContext context) {
    final status = ItemStatusExt.fromString(item.status);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CategoryBadge(type: type, small: true),
          const SizedBox(height: 10),
          Text(
            item.title,
            style: AppTextStyles.titleSmall,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          _BackRow(
            icon: Icons.circle,
            iconColor: _statusColor(status),
            label: status.label,
          ),
          if (item.overview != null) ...[
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                item.overview!,
                style: AppTextStyles.bodySmall,
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ] else
            const Spacer(),
          if (item.reminderEnabled && item.reminderAt != null)
            _BackRow(
              icon: Icons.alarm,
              iconColor: AppColors.accent,
              label: 'Reminder set',
            ),
          const SizedBox(height: 4),
          Text(
            'Tap to open  •  Long press to flip back',
            style: AppTextStyles.bodySmall.copyWith(fontSize: 9),
          ),
        ],
      ),
    );
  }

  Color _statusColor(ItemStatus s) => switch (s) {
        ItemStatus.want => AppColors.primary,
        ItemStatus.inProgress => AppColors.accent,
        ItemStatus.completed => AppColors.success,
        ItemStatus.dropped => AppColors.textMuted,
      };
}

class _BackRow extends StatelessWidget {
  const _BackRow({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 8, color: iconColor),
        const SizedBox(width: 6),
        Text(label, style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
      ],
    );
  }
}

// ─── Poster ──────────────────────────────────────────────────────────────────

class _Poster extends StatefulWidget {
  const _Poster({
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
  State<_Poster> createState() => _PosterState();
}

class _PosterState extends State<_Poster> {
  final _containerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (widget.image == null) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
        child: Container(
          color: AppColors.surfaceLight,
          child: Center(
            child: Icon(_iconForType(widget.type),
                size: 40, color: AppColors.textMuted),
          ),
        ),
      );
    }

    Widget image;

    if (widget.enableParallax) {
      final scrollable = Scrollable.maybeOf(context);
      if (scrollable != null) {
        image = AnimatedBuilder(
          animation: scrollable.position,
          builder: (_, __) {
            double offset = 0;
            final box = _containerKey.currentContext?.findRenderObject()
                as RenderBox?;
            final scrollBox =
                scrollable.context.findRenderObject() as RenderBox?;
            if (box != null && scrollBox != null && box.attached) {
              final pos =
                  box.localToGlobal(Offset.zero, ancestor: scrollBox);
              final viewport = scrollable.position.viewportDimension;
              final fraction = (pos.dy / viewport).clamp(0.0, 1.0);
              offset = (fraction - 0.5) * 36.0;
            }
            return ClipRect(
              child: OverflowBox(
                maxHeight: double.infinity,
                child: Transform.translate(
                  offset: Offset(0, offset),
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
        errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceLight),
      );
    }

    final clipped = ClipRRect(
      key: _containerKey,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
      child: image,
    );

    if (widget.heroTag != null && widget.image != null) {
      return Hero(tag: widget.heroTag!, child: clipped);
    }
    return clipped;
  }

  IconData _iconForType(ItemType type) => switch (type) {
        ItemType.movie => Icons.movie_rounded,
        ItemType.series => Icons.tv_rounded,
        ItemType.anime => Icons.auto_awesome,
        ItemType.game => Icons.sports_esports_rounded,
        ItemType.product => Icons.shopping_bag_rounded,
      };
}

// ─── Info row ────────────────────────────────────────────────────────────────

class _Info extends StatelessWidget {
  const _Info({required this.item, required this.type});

  final VaultItem item;
  final ItemType type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CategoryBadge(type: type, small: true),
          const SizedBox(height: 6),
          Text(
            item.title,
            style: AppTextStyles.titleSmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          _StatusRow(item: item, type: type),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.item, required this.type});

  final VaultItem item;
  final ItemType type;

  @override
  Widget build(BuildContext context) {
    final status = ItemStatusExt.fromString(item.status);

    if (status == ItemStatus.inProgress) {
      return _progressWidget;
    }

    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: _statusColor(status),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(status.label, style: AppTextStyles.bodySmall),
        if (item.reminderEnabled && item.reminderAt != null) ...[
          const Spacer(),
          const Icon(Icons.alarm, size: 12, color: AppColors.accent),
        ],
      ],
    );
  }

  Widget get _progressWidget {
    final progress = switch (ItemTypeExt.fromString(item.itemType)) {
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
      return Text('In Progress',
          style: AppTextStyles.bodySmall
              .copyWith(color: AppColors.accent));
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
            minHeight: 3,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          '${(progress * 100).round()}%',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.accent),
        ),
      ],
    );
  }

  Color _statusColor(ItemStatus status) => switch (status) {
        ItemStatus.want => AppColors.primary,
        ItemStatus.inProgress => AppColors.accent,
        ItemStatus.completed => AppColors.success,
        ItemStatus.dropped => AppColors.textMuted,
      };
}
