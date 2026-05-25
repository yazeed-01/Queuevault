import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Internal layout + animation flags ───────────────────────────────────────

enum VaultLayout { grid, swimlanes, heroFeed, deckSpotlight, wheelBrowser }

class LayoutPrefs {
  const LayoutPrefs({
    this.preset = VaultPreset.wheelBrowser,
    this.layout = VaultLayout.grid,
    this.scrollReveal = false,
    this.parallaxPosters = false,
    this.staggeredGrid = false,
    this.cardFlip = false,
    this.heroTransitions = false,
  });

  final VaultPreset preset;
  final VaultLayout layout;
  final bool scrollReveal;
  final bool parallaxPosters;
  final bool staggeredGrid;
  final bool cardFlip;
  final bool heroTransitions;
}

// ─── 8 Design presets ────────────────────────────────────────────────────────

enum VaultPreset {
  classic,
  masonry,
  scrollReveal,
  parallax,
  cardFlip,
  netflix,
  heroFeed,
  deckSpotlight,
  wheelBrowser,
}

extension VaultPresetExt on VaultPreset {
  String get label => switch (this) {
        VaultPreset.classic       => 'Classic',
        VaultPreset.masonry       => 'Masonry',
        VaultPreset.scrollReveal  => 'Scroll Reveal',
        VaultPreset.parallax      => 'Parallax',
        VaultPreset.cardFlip      => 'Card Flip',
        VaultPreset.netflix       => 'Netflix Lanes',
        VaultPreset.heroFeed      => 'Hero Feed',
        VaultPreset.deckSpotlight => 'Deck Spotlight',
        VaultPreset.wheelBrowser  => 'Wheel Browser',
      };

  String get description => switch (this) {
        VaultPreset.classic       => 'Simple 2-column grid, no effects',
        VaultPreset.masonry       => 'Pinterest-style varying card heights',
        VaultPreset.scrollReveal  => 'Cards animate in as you scroll',
        VaultPreset.parallax      => 'Posters shift on scroll for depth',
        VaultPreset.cardFlip      => 'Long press any card to flip it',
        VaultPreset.netflix       => 'Rows grouped by category like Netflix',
        VaultPreset.heroFeed      => 'Active item as cinematic hero banner',
        VaultPreset.deckSpotlight => 'Swipe through in-progress items',
        VaultPreset.wheelBrowser  => 'Spin the revolver cylinder to browse',
      };

  IconData get icon => switch (this) {
        VaultPreset.classic       => Icons.grid_view_rounded,
        VaultPreset.masonry       => Icons.dashboard_rounded,
        VaultPreset.scrollReveal  => Icons.visibility_rounded,
        VaultPreset.parallax      => Icons.layers_rounded,
        VaultPreset.cardFlip      => Icons.flip_rounded,
        VaultPreset.netflix       => Icons.view_stream_rounded,
        VaultPreset.heroFeed      => Icons.featured_play_list_rounded,
        VaultPreset.deckSpotlight => Icons.style_rounded,
        VaultPreset.wheelBrowser  => Icons.rotate_right_rounded,
      };

  Color get accentColor => switch (this) {
        VaultPreset.classic       => const Color(0xFF8892A4),
        VaultPreset.masonry       => const Color(0xFFFFD600),
        VaultPreset.scrollReveal  => const Color(0xFF00F0FF),
        VaultPreset.parallax      => const Color(0xFF00FF41),
        VaultPreset.cardFlip      => const Color(0xFFFF0055),
        VaultPreset.netflix       => const Color(0xFFE50914),
        VaultPreset.heroFeed      => const Color(0xFF00F0FF),
        VaultPreset.deckSpotlight => const Color(0xFF00FF41),
        VaultPreset.wheelBrowser  => const Color(0xFFFF9500),
      };

  /// Tags shown as small chips on the preset card
  List<String> get tags => switch (this) {
        VaultPreset.classic       => ['Grid', 'Simple'],
        VaultPreset.masonry       => ['Grid', 'Staggered'],
        VaultPreset.scrollReveal  => ['Grid', 'Animated'],
        VaultPreset.parallax      => ['Grid', 'Parallax', 'Hero'],
        VaultPreset.cardFlip      => ['Grid', 'Flip', 'Hero'],
        VaultPreset.netflix       => ['Swimlanes', 'Grouped'],
        VaultPreset.heroFeed      => ['Hero', 'Cinematic', 'Hero'],
        VaultPreset.deckSpotlight => ['Swipe', 'Spotlight'],
        VaultPreset.wheelBrowser  => ['Cylinder', 'Revolver', 'Browse'],
      };

  LayoutPrefs get prefs => switch (this) {
        VaultPreset.classic => LayoutPrefs(
            preset: this,
            layout: VaultLayout.grid,
          ),
        VaultPreset.masonry => LayoutPrefs(
            preset: this,
            layout: VaultLayout.grid,
            staggeredGrid: true,
          ),
        VaultPreset.scrollReveal => LayoutPrefs(
            preset: this,
            layout: VaultLayout.grid,
            scrollReveal: true,
          ),
        VaultPreset.parallax => LayoutPrefs(
            preset: this,
            layout: VaultLayout.grid,
            parallaxPosters: true,
            heroTransitions: true,
          ),
        VaultPreset.cardFlip => LayoutPrefs(
            preset: this,
            layout: VaultLayout.grid,
            cardFlip: true,
            heroTransitions: true,
          ),
        VaultPreset.netflix => LayoutPrefs(
            preset: this,
            layout: VaultLayout.swimlanes,
            scrollReveal: true,
          ),
        VaultPreset.heroFeed => LayoutPrefs(
            preset: this,
            layout: VaultLayout.heroFeed,
            heroTransitions: true,
            parallaxPosters: true,
          ),
        VaultPreset.deckSpotlight => LayoutPrefs(
            preset: this,
            layout: VaultLayout.deckSpotlight,
            heroTransitions: true,
          ),
        VaultPreset.wheelBrowser => LayoutPrefs(
            preset: this,
            layout: VaultLayout.wheelBrowser,
            heroTransitions: true,
          ),
      };
}

// ─── Notifier ────────────────────────────────────────────────────────────────

class LayoutPrefsNotifier extends StateNotifier<LayoutPrefs> {
  LayoutPrefsNotifier() : super(VaultPreset.wheelBrowser.prefs) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final idx = prefs.getInt('vault_preset') ?? VaultPreset.wheelBrowser.index;
    final preset =
        VaultPreset.values[idx.clamp(0, VaultPreset.values.length - 1)];
    state = preset.prefs;
  }

  Future<void> applyPreset(VaultPreset preset) async {
    state = preset.prefs;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('vault_preset', preset.index);
  }
}

final layoutPrefsProvider =
    StateNotifierProvider<LayoutPrefsNotifier, LayoutPrefs>(
  (_) => LayoutPrefsNotifier(),
);
