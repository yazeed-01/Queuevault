import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../../features/vault/data/models/item_type.dart';

class CategoryBadge extends StatelessWidget {
  const CategoryBadge({super.key, required this.type, this.small = false});

  final ItemType type;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final (label, color, icon) = switch (type) {
      ItemType.movie => ('MOVIE', AppColors.watchColor, Icons.movie_rounded),
      ItemType.series =>
        ('SERIES', AppColors.seriesColor, Icons.tv_rounded),
      ItemType.anime => ('ANIME', AppColors.animeColor, Icons.auto_awesome),
      ItemType.game => ('GAME', AppColors.playColor, Icons.sports_esports_rounded),
      ItemType.product => ('BUY', AppColors.buyColor, Icons.shopping_bag_rounded),
    };

    final size = small ? 10.0 : 11.0;
    final iconSize = small ? 10.0 : 12.0;
    final padding = small
        ? const EdgeInsets.symmetric(horizontal: 6, vertical: 3)
        : const EdgeInsets.symmetric(horizontal: 8, vertical: 4);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: color,
              fontSize: size,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
