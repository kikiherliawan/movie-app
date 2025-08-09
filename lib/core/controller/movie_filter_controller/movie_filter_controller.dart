import 'package:get/get.dart';
import 'package:movie_app/core/network/dio_api_client.dart';
import 'package:movie_app/core/response/movie_list_response.dart';

class MovieFilterController extends GetxController {
  final DioApiClient _client = DioApiClient();

  var isLoading = false.obs;
  var filteredMovies = <Result>[].obs;
  var errorMessage = ''.obs;

  Future<void> filterMovies({int? genreId, int? year}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _client.dio.get(
        '/discover/movie',
        queryParameters: {
          if (genreId != null) 'with_genres': genreId,
          if (year != null) 'primary_release_year': year,
        },
      );

      final movieList = MovieListResponse.fromJson(response.data);
      filteredMovies.assignAll(movieList.results);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
