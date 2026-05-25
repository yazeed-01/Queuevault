import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/vault/presentation/vault_screen.dart';
import '../../features/add_item/presentation/add_item_screen.dart';
import '../../features/add_item/presentation/item_form_screen.dart';
import '../../features/item_detail/presentation/item_detail_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/settings/presentation/design_presets_page.dart';
import '../../features/settings/presentation/api_keys_page.dart';
import '../../features/discover/presentation/discover_screen.dart';
import '../../features/discover/presentation/discover_detail_screen.dart';
import '../../features/vault/data/models/item_type.dart';
import '../../features/categories/presentation/category_manager_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../database/app_database.dart';
import '../network/search_result.dart';

GoRouter? _appRouter;
GoRouter get appRouter => _appRouter!;

GoRouter makeRouter({required bool onboardingDone}) {
  _appRouter = _buildRouter(onboardingDone: onboardingDone);
  return _appRouter!;
}

GoRouter _buildRouter({required bool onboardingDone}) => GoRouter(
  initialLocation: onboardingDone ? '/vault' : '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) => _fade(const OnboardingScreen()),
    ),
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/vault',
          pageBuilder: (context, state) => _fade(const VaultScreen()),
        ),
        GoRoute(
          path: '/discover',
          pageBuilder: (context, state) => _fade(const DiscoverScreen()),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => _fade(const SettingsScreen()),
        ),
      ],
    ),
    GoRoute(
      path: '/categories',
      pageBuilder: (context, state) => _slide(const CategoryManagerScreen()),
    ),
    GoRoute(
      path: '/design-presets',
      pageBuilder: (context, state) => _slide(const DesignPresetsPage()),
    ),
    GoRoute(
      path: '/api-keys',
      pageBuilder: (context, state) => _slide(const ApiKeysPage()),
    ),
    GoRoute(
      path: '/add',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return _slide(AddItemScreen(
          preselectedType: extra?['type'],
          sharedUrl: extra?['url'],
          initialQuery: extra?['query'],
        ));
      },
    ),
    GoRoute(
      path: '/item/:id',
      pageBuilder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return _slide(ItemDetailScreen(itemId: id));
      },
    ),
    GoRoute(
      path: '/add/manual',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final type = extra?['type'] != null
            ? ItemTypeExt.fromString(extra!['type'] as String)
            : ItemType.movie;
        final existing = extra?['item'] as VaultItem?;
        return _slide(ItemFormScreen(type: type, existingItem: existing));
      },
    ),
    GoRoute(
      path: '/discover/detail',
      pageBuilder: (context, state) {
        final result = state.extra as SearchResult;
        return _slide(DiscoverDetailScreen(result: result));
      },
    ),
  ],
);

CustomTransitionPage<T> _fade<T>(Widget child) => CustomTransitionPage<T>(
      child: child,
      transitionsBuilder: (_, animation, __, widget) =>
          FadeTransition(opacity: animation, child: widget),
    );

CustomTransitionPage<T> _slide<T>(Widget child) => CustomTransitionPage<T>(
      child: child,
      transitionsBuilder: (_, animation, __, widget) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.04),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
        child: FadeTransition(opacity: animation, child: widget),
      ),
    );

class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.child});
  final Widget child;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  static const _routes = ['/vault', '/discover', '/settings'];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final selectedIndex = _routes.indexWhere((r) => location.startsWith(r));

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
        onDestinationSelected: (i) => context.go(_routes[i]),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.video_library_outlined),
            selectedIcon: Icon(Icons.video_library),
            label: 'Vault',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Discover',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
