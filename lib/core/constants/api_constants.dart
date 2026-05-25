class ApiConstants {
  ApiConstants._();

  // TMDB
  static const tmdbBase = 'https://api.themoviedb.org/3';
  static const tmdbImageBase = 'https://image.tmdb.org/t/p';
  static const tmdbPosterW500 = '$tmdbImageBase/w500';
  static const tmdbBackdropW1280 = '$tmdbImageBase/w1280';

  // RAWG
  static const rawgBase = 'https://api.rawg.io/api';

  // AniList
  static const anilistGraphql = 'https://graphql.anilist.co';

  // UpcItemDB (no API key required)
  static const upcItemDbBase = 'https://api.upcitemdb.com/prod/trial';
}
