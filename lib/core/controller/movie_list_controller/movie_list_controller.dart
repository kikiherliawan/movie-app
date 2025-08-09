import 'package:movie_app/core/network/dio_api_client.dart';
import 'package:movie_app/core/response/movie_list_response.dart';
import 'package:get/get.dart';

class MovieListController extends GetxController {
  final DioApiClient _client = DioApiClient();

  var isLoading = false.obs;
  var isLoadingMore = false.obs; // tambahan buat loading bawah
  var movies = <Result>[].obs;
  var errorMessage = ''.obs;

  // State search & filter
  var isSearching = false.obs;
  var searchQuery = ''.obs;
  int? currentGenre;
  int? currentYear;

  // Pagination
  int currentPage = 1;
  int totalPages = 1;

  @override
  void onInit() {
    super.onInit();
    fetchMovies(reset: true);
  }

  Future<void> fetchMovies({bool reset = false}) async {
    try {
      if (reset) {
        isLoading.value = true;
        currentPage = 1;
        movies.clear();
      } else {
        if (isLoadingMore.value || currentPage > totalPages) return;
        isLoadingMore.value = true;
      }

      errorMessage.value = '';

      String endpoint;
      Map<String, dynamic> params = {
        "page": currentPage,
        "include_adult": true,
      };

      if (isSearching.value && searchQuery.value.isNotEmpty) {
        endpoint = '/search/movie';
        params['query'] = searchQuery.value;
      } else if (currentGenre != null || currentYear != null) {
        endpoint = '/discover/movie';
        if (currentGenre != null) params['with_genres'] = currentGenre;
        if (currentYear != null) params['primary_release_year'] = currentYear;
        params['sort_by'] = 'popularity.desc';
      } else {
        endpoint = '/discover/movie';
        params['sort_by'] = 'popularity.desc';
      }

      final response = await _client.dio.get(endpoint, queryParameters: params);
      final movieList = MovieListResponse.fromJson(response.data);

      totalPages = movieList.totalPages;
      movies.addAll(movieList.results);
      currentPage++;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void setIsSearching(bool value) {
    isSearching.value = value;
    if (!value) {
      searchQuery.value = '';
      fetchMovies(reset: true);
    }
  }

  void searchMovies(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      setIsSearching(false);
    } else {
      setIsSearching(true);
      fetchMovies(reset: true);
    }
  }
}
