import 'package:movie_app/core/network/dio_api_client.dart';
import 'package:movie_app/core/response/movie_detail_response.dart';
import 'package:movie_app/core/response/movie_list_response.dart';

class MovieService {
  final serviceName = '/movie';

  Future<MovieListResponse> fetchMovies(String filter, int page) async {
    try {
      if (filter.isEmpty) {
        throw Exception('Filter tidak boleh kosong');
      }

      final response = await DioApiClient().dio.get(
        '$serviceName/$filter?page=$page',
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return MovieListResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load movies: Data kosong atau format salah');
      }
    } catch (e) {
      throw Exception('Failed to load movies: ${e.toString()}');
    }
  }
  //

  Future<MovieDetailResponse> fetchMovieDetails(int movieId) async {
    try {
      final response = await DioApiClient().dio.get('$serviceName/$movieId');
      if (response.statusCode == 200) {
        return MovieDetailResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load movie details');
      }
    } catch (e) {
      throw Exception('Failed to load movie details: $e');
    }
  }

  Future<MovieListResponse> fetchTrending({int page = 1}) async {
    try {
      final response = await DioApiClient().dio.get(
        '/trending/movie/day?page=$page',
      );
      if (response.statusCode == 200) {
        return MovieListResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load trending movies');
      }
    } catch (e) {
      throw Exception('Failed to load trending movies: $e');
    }
  }

  Future<MovieListResponse> fetchKoreanDrama({int page = 1}) async {
    try {
      final response = await DioApiClient().dio.get(
        '/discover/tv?page=$page&with_origin_country=KR',
      );
      if (response.statusCode == 200) {
        return MovieListResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load Korean dramas');
      }
    } catch (e) {
      throw Exception('Failed to load Korean dramas: $e');
    }
  }
}
