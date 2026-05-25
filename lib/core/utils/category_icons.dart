import 'package:flutter/material.dart';

class CategoryIcons {
  CategoryIcons._();

  static const iconMap = {
    'movie': Icons.movie_rounded,
    'tv': Icons.tv_rounded,
    'auto_awesome': Icons.auto_awesome,
    'sports_esports': Icons.sports_esports_rounded,
    'shopping_bag': Icons.shopping_bag_rounded,
    'book': Icons.menu_book_rounded,
    'music_note': Icons.music_note_rounded,
    'headphones': Icons.headphones_rounded,
    'restaurant': Icons.restaurant_rounded,
    'sports': Icons.sports_rounded,
    'fitness': Icons.fitness_center_rounded,
    'travel': Icons.flight_rounded,
    'photo': Icons.photo_camera_rounded,
    'code': Icons.code_rounded,
    'science': Icons.science_rounded,
    'brush': Icons.brush_rounded,
    'pets': Icons.pets_rounded,
    'star': Icons.star_rounded,
    'favorite': Icons.favorite_rounded,
    'bookmark': Icons.bookmark_rounded,
    'category': Icons.category_rounded,
    'local_movies': Icons.local_movies_rounded,
    'videogame': Icons.videogame_asset_rounded,
    'comic': Icons.auto_stories_rounded,
    'podcast': Icons.podcasts_rounded,
  };

  static IconData resolve(String name) =>
      iconMap[name] ?? Icons.category_rounded;
}
