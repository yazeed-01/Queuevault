import '../../features/vault/data/models/item_type.dart';

class SearchResult {
  const SearchResult({
    required this.id,
    required this.title,
    required this.type,
    this.posterUrl,
    this.backdropUrl,
    this.overview,
    this.year,
    this.genre,
    this.extraData = const {},
  });

  final String id;
  final String title;
  final ItemType type;
  final String? posterUrl;
  final String? backdropUrl;
  final String? overview;
  final int? year;
  final String? genre;
  final Map<String, dynamic> extraData;
}
