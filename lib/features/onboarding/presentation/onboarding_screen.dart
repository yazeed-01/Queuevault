import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

const _kOnboardingDone = 'onboarding_complete';

// ─── Slide data ────────────────────────────────────────────────────────────

class _Slide {
  const _Slide({
    required this.eyebrow,
    required this.title,
    required this.body,
    required this.icon,
    required this.accent,
    required this.chips,
  });
  final String eyebrow;
  final String title;
  final String body;
  final IconData icon;
  final Color accent;
  final List<String> chips;
}

const _slides = [
  _Slide(
    eyebrow: 'WELCOME',
    title: 'Your personal\nvault awaits.',
    body: 'QueueVault is the one place for everything you want to watch, play, or buy — beautifully organised and always with you.',
    icon: Icons.video_library_rounded,
    accent: AppColors.accent,
    chips: ['100% offline', 'No account needed', 'Dark & fast'],
  ),
  _Slide(
    eyebrow: 'EVERY FORMAT',
    title: 'Movies, Anime,\nGames & more.',
    body: 'Five built-in categories, each with its own smart fields — episode tracking for series, playtime for games, price alerts for products.',
    icon: Icons.auto_awesome_rounded,
    accent: AppColors.tertiary,
    chips: ['Movies & Series', 'Anime', 'Games', 'Products'],
  ),
  _Slide(
    eyebrow: 'TRACK PROGRESS',
    title: 'Always know\nwhere you left off.',
    body: 'Tag anything as Want, In Progress, Completed, or Dropped. Rate it, add notes, and watch your collection grow.',
    icon: Icons.track_changes_rounded,
    accent: AppColors.primary,
    chips: ['Want', 'In Progress', 'Completed', 'Dropped'],
  ),
  _Slide(
    eyebrow: 'REMINDERS',
    title: 'Never forget\nwhat\'s next.',
    body: 'Set a notification for any item — a release date, the next episode night, or when a product goes on sale.',
    icon: Icons.notifications_active_rounded,
    accent: AppColors.warning,
    chips: ['Local notifications', 'Pick any date & time'],
  ),
  _Slide(
    eyebrow: 'BACKUP & SYNC',
    title: 'Your vault,\nalways safe.',
    body: 'Connect Google to back up your entire vault to Drive. One tap to restore, or auto-sync every time you close the app.',
    icon: Icons.cloud_done_rounded,
    accent: AppColors.accent,
    chips: ['Google Drive', 'Auto-sync', 'Full restore'],
  ),
];

// ─── Screen ────────────────────────────────────────────────────────────────

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final _pageController = PageController();
  int _current = 0;

  late final AnimationController _orbController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pageController.dispose();
    _orbController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOnboardingDone, true);
    if (mounted) context.go('/vault');
  }

  void _next() {
    if (_current < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_current];
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Animated ambient orb
          _AmbientOrb(controller: _orbController, color: slide.accent),

          // Page content
          PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _current = i),
            itemCount: _slides.length,
            itemBuilder: (_, i) => _SlidePage(
              slide: _slides[i],
              isActive: i == _current,
            ),
          ),

          // Top: Skip
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 20,
            child: AnimatedOpacity(
              opacity: _current < _slides.length - 1 ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: TextButton(
                onPressed: _current < _slides.length - 1 ? _finish : null,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text('Skip'),
              ),
            ),
          ),

          // Bottom: dots + button
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 32,
            left: 28,
            right: 28,
            child: _BottomBar(
              current: _current,
              total: _slides.length,
              accent: slide.accent,
              isLast: _current == _slides.length - 1,
              onNext: _next,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Ambient orb ───────────────────────────────────────────────────────────

class _AmbientOrb extends StatelessWidget {
  const _AmbientOrb({required this.controller, required this.color});
  final AnimationController controller;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context2, child2) {
        final t = controller.value;
        return Positioned(
          top: -80 + 30 * math.sin(t * math.pi),
          left: -60 + 20 * math.cos(t * math.pi),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            width: 340,
            height: 340,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  color.withValues(alpha: 0.18),
                  color.withValues(alpha: 0.04),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Slide page ────────────────────────────────────────────────────────────

class _SlidePage extends StatelessWidget {
  const _SlidePage({required this.slide, required this.isActive});
  final _Slide slide;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(flex: 2),

          // Icon orb
          Center(
            child: _GlowOrb(icon: slide.icon, color: slide.accent, active: isActive),
          ),

          const Spacer(flex: 2),

          // Eyebrow
          if (isActive)
            Text(slide.eyebrow, style: AppTextStyles.labelLarge.copyWith(
              color: slide.accent,
              letterSpacing: 2.5,
              fontSize: 11,
            ))
                .animate()
                .fadeIn(delay: 100.ms, duration: 380.ms)
                .slideY(begin: 0.3, end: 0, curve: Curves.easeOut),

          const SizedBox(height: 10),

          // Title
          if (isActive)
            Text(slide.title, style: AppTextStyles.displayMedium.copyWith(
              height: 1.18,
              fontSize: 30,
            ))
                .animate()
                .fadeIn(delay: 180.ms, duration: 400.ms)
                .slideY(begin: 0.3, end: 0, curve: Curves.easeOut),

          const SizedBox(height: 16),

          // Body
          if (isActive)
            Text(slide.body, style: AppTextStyles.bodyLarge.copyWith(height: 1.65))
                .animate()
                .fadeIn(delay: 260.ms, duration: 400.ms)
                .slideY(begin: 0.3, end: 0, curve: Curves.easeOut),

          const SizedBox(height: 24),

          // Chips
          if (isActive)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: slide.chips.map((c) => _Chip(label: c, color: slide.accent)).toList(),
            )
                .animate()
                .fadeIn(delay: 340.ms, duration: 400.ms)
                .slideY(begin: 0.2, end: 0, curve: Curves.easeOut),

          // Space for bottom bar
          const SizedBox(height: 110),
        ],
      ),
    );
  }
}

// ─── Glow orb with icon ────────────────────────────────────────────────────

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.icon, required this.color, required this.active});
  final IconData icon;
  final Color color;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.08),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1.5),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.22), blurRadius: 40, spreadRadius: 4),
          BoxShadow(color: color.withValues(alpha: 0.10), blurRadius: 80, spreadRadius: 12),
        ],
      ),
      child: Icon(icon, size: 54, color: color)
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .scaleXY(begin: 0.95, end: 1.05, duration: 2400.ms, curve: Curves.easeInOut),
    )
        .animate()
        .scaleXY(begin: 0.6, end: 1.0, duration: 500.ms, curve: Curves.easeOutBack)
        .fadeIn(duration: 400.ms);
  }
}

// ─── Feature chip ──────────────────────────────────────────────────────────

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.22), width: 1),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: color.withValues(alpha: 0.85),
          letterSpacing: 0.3,
          fontSize: 12,
        ),
      ),
    );
  }
}

// ─── Bottom bar ────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.current,
    required this.total,
    required this.accent,
    required this.isLast,
    required this.onNext,
  });
  final int current;
  final int total;
  final Color accent;
  final bool isLast;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Dots
        Row(
          children: List.generate(total, (i) {
            final active = i == current;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.only(right: 6),
              width: active ? 24 : 7,
              height: 7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: active ? accent : AppColors.textMuted.withValues(alpha: 0.5),
                boxShadow: active
                    ? [BoxShadow(color: accent.withValues(alpha: 0.4), blurRadius: 8)]
                    : null,
              ),
            );
          }),
        ),

        const Spacer(),

        // Next / Get Started button
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(color: accent.withValues(alpha: 0.35), blurRadius: 20, spreadRadius: 2),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onNext,
              borderRadius: BorderRadius.circular(50),
              splashColor: Colors.white.withValues(alpha: 0.15),
              child: AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isLast ? 24 : 18,
                    vertical: 14,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isLast) ...[
                        Text(
                          "Let's Go",
                          style: AppTextStyles.titleSmall.copyWith(
                            color: AppColors.background,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Icon(
                        isLast ? Icons.rocket_launch_rounded : Icons.arrow_forward_rounded,
                        color: AppColors.background,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
