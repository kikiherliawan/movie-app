import 'package:get/get.dart';
import 'package:movie_app/core/network/dio_api_client.dart';
import 'package:movie_app/core/response/movie_list_response.dart';

// class SearchController extends GetxController {
//   var isSearching = false.obs;
//   var searchQuery = ''.obs;

//   void startSearch() {
//     isSearching.value = true;
//   }

//   void stopSearch() {
//     isSearching.value = false;
//     searchQuery.value = '';
//   }

//   void setQuery(String value) {
//     searchQuery.value = value;
//   }
// }

class MovieSearchController extends GetxController {
  final DioApiClient _client = DioApiClient();

  var isLoading = false.obs;
  var searchResults = <Result>[].obs;
  var errorMessage = ''.obs;

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _client.dio.get(
        '/search/movie',
        queryParameters: {'query': query},
      );

      final movieList = MovieListResponse.fromJson(response.data);
      searchResults.assignAll(movieList.results);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
