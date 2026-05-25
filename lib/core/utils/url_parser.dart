import '../../features/vault/data/models/item_type.dart';

class UrlParser {
  UrlParser._();

  static const _watchDomains = [
    'netflix.com', 'imdb.com', 'letterboxd.com',
    'themoviedb.org', 'rottentomatoes.com', 'hulu.com',
    'disneyplus.com', 'primevideo.com', 'hbo.com', 'apple.tv',
  ];

  static const _seriesDomains = [
    'tv.apple.com',
  ];

  static const _youtubeDomains = [
    'youtube.com', 'youtu.be',
  ];

  static const _animeDomains = [
    'myanimelist.net', 'anilist.co', 'crunchyroll.com',
    'funimation.com', 'hidive.com', 'anidb.net',
  ];

  static const _gameDomains = [
    'store.steampowered.com', 'epicgames.com', 'gog.com',
    'ign.com', 'metacritic.com', 'rawg.io', 'xbox.com',
    'playstation.com', 'nintendo.com', 'g2a.com',
  ];

  static const _buyDomains = [
    'amazon.com', 'amazon.co.uk', 'bestbuy.com', 'newegg.com',
    'walmart.com', 'target.com', 'bhphotovideo.com', 'adorama.com',
    'ebay.com', 'aliexpress.com',
  ];

  /// Returns (itemType, cleanedUrl)
  static ({ItemType type, String url}) detect(String sharedText) {
    final url = _extractUrl(sharedText);
    final host = _host(url);

    if (_matches(host, _animeDomains)) return (type: ItemType.anime, url: url);
    if (_matches(host, _gameDomains)) return (type: ItemType.game, url: url);
    if (_matches(host, _buyDomains)) return (type: ItemType.product, url: url);
    if (_matches(host, _youtubeDomains)) return (type: ItemType.series, url: url);
    if (_matches(host, _seriesDomains)) return (type: ItemType.series, url: url);
    if (_matches(host, _watchDomains)) return (type: ItemType.movie, url: url);

    // Default to movie for unknown URLs
    return (type: ItemType.movie, url: url);
  }

  static String _extractUrl(String text) {
    final uri = RegExp(r'https?://[^\s]+').firstMatch(text);
    return uri?.group(0) ?? text.trim();
  }

  static String _host(String url) {
    try {
      return Uri.parse(url).host.replaceFirst('www.', '');
    } catch (_) {
      return '';
    }
  }

  static bool _matches(String host, List<String> domains) =>
      domains.any((d) => host == d || host.endsWith('.$d'));
}
