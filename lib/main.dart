import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_text_styles.dart';
import 'core/notifications/notification_service.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/url_parser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF050A18),
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Show splash immediately — init happens inside the widget tree
  runApp(const ProviderScope(child: QueueVaultApp()));
}

class QueueVaultApp extends StatefulWidget {
  const QueueVaultApp({super.key});

  @override
  State<QueueVaultApp> createState() => _QueueVaultAppState();
}

class _QueueVaultAppState extends State<QueueVaultApp> {
  GoRouter? _router;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await dotenv.load(fileName: '.env');
    await NotificationService.init();
    final prefs = await SharedPreferences.getInstance();
    final onboardingDone = prefs.getBool('onboarding_complete') ?? false;
    if (!mounted) return;
    setState(() => _router = makeRouter(onboardingDone: onboardingDone));
    _handleSharedMedia();
  }

  void _handleSharedMedia() {
    ReceiveSharingIntent.instance.getInitialMedia().then((media) {
      final text = _extractText(media);
      if (text != null) _navigateToAdd(text);
    });
    ReceiveSharingIntent.instance.getMediaStream().listen((media) {
      final text = _extractText(media);
      if (text != null) _navigateToAdd(text);
    });
  }

  String? _extractText(List<SharedMediaFile> media) {
    if (media.isEmpty) return null;
    final item = media.first;
    if (item.type == SharedMediaType.text || item.type == SharedMediaType.url) {
      return item.path;
    }
    return null;
  }

  void _navigateToAdd(String sharedText) {
    final detected = UrlParser.detect(sharedText);
    _router?.push('/add', extra: {'type': detected.type.name, 'url': detected.url});
  }

  @override
  Widget build(BuildContext context) {
    final router = _router;
    if (router == null) {
      return MaterialApp(
        title: 'QueueVault',
        theme: AppTheme.dark,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        home: const _SplashScreen(),
      );
    }
    return MaterialApp.router(
      title: 'QueueVault',
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

// ─── Animated splash screen ───────────────────────────────────────────────────

class _SplashScreen extends StatefulWidget {
  const _SplashScreen();

  @override
  State<_SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<_SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Glowing logo icon
            AnimatedBuilder(
              animation: _pulseCtrl,
              builder: (_, __) => Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColors.primary
                      .withValues(alpha: 0.10 + _pulseCtrl.value * 0.06),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: AppColors.primary
                        .withValues(alpha: 0.35 + _pulseCtrl.value * 0.25),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary
                          .withValues(alpha: 0.18 + _pulseCtrl.value * 0.14),
                      blurRadius: 32 + _pulseCtrl.value * 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.video_library_rounded,
                    size: 44, color: AppColors.primary),
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms)
                .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1, 1),
                    curve: Curves.easeOutBack),

            const SizedBox(height: 20),

            Text('QueueVault', style: AppTextStyles.titleLarge)
                .animate(delay: 150.ms)
                .fadeIn(duration: 350.ms)
                .slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic),

            const SizedBox(height: 6),

            Text('Your personal media vault',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textMuted))
                .animate(delay: 220.ms)
                .fadeIn(duration: 300.ms),

            const SizedBox(height: 40),

            // Animated loading dots
            _LoadingDots(controller: _pulseCtrl)
                .animate(delay: 300.ms)
                .fadeIn(duration: 300.ms),
          ],
        ),
      ),
    );
  }
}

class _LoadingDots extends AnimatedWidget {
  const _LoadingDots({required AnimationController controller})
      : super(listenable: controller);

  @override
  Widget build(BuildContext context) {
    final t = (listenable as AnimationController).value;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        // Stagger each dot by 0.33 of the cycle
        final phase = ((t + i * 0.33) % 1.0);
        final scale = 0.6 + (phase < 0.5 ? phase * 0.8 : (1 - phase) * 0.8);
        final opacity = 0.3 + (phase < 0.5 ? phase * 1.4 : (1 - phase) * 1.4);
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: Transform.scale(
            scale: scale.clamp(0.6, 1.0),
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.primary
                    .withValues(alpha: opacity.clamp(0.3, 1.0)),
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }),
    );
  }
}
