import 'package:dio/dio.dart';

Dio buildTmdbDio(String bearerToken) {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    headers: {'Authorization': 'Bearer $bearerToken'},
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
  ));
  return dio;
}

Dio buildRawgDio(String apiKey) {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.rawg.io/api',
    queryParameters: {'key': apiKey},
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
  ));
  return dio;
}

Dio buildAnilistDio() {
  return Dio(BaseOptions(
    baseUrl: 'https://graphql.anilist.co',
    headers: {'Content-Type': 'application/json'},
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
  ));
}

Dio buildBestBuyDio(String apiKey) {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.bestbuy.com/v1',
    queryParameters: {'apiKey': apiKey, 'format': 'json'},
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
  ));
  return dio;
}
