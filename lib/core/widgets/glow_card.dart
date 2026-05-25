import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class GlowCard extends StatelessWidget {
  const GlowCard({
    super.key,
    required this.child,
    this.glowColor = AppColors.primaryGlow,
    this.borderColor = AppColors.cardBorder,
    this.borderRadius = 16.0,
    this.padding,
    this.onTap,
    this.glowIntensity = 1.0,
  });

  final Widget child;
  final Color glowColor;
  final Color borderColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final double glowIntensity;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: glowColor.withValues(alpha: 0.3 * glowIntensity),
              blurRadius: 20 * glowIntensity,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: glowColor.withValues(alpha: 0.1 * glowIntensity),
              blurRadius: 40 * glowIntensity,
              spreadRadius: 4,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: padding != null
              ? Padding(padding: padding!, child: child)
              : child,
        ),
      ),
    );
  }
}
