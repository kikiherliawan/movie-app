import 'package:get/get.dart';
import 'package:movie_app/core/response/movie_list_response.dart';
import 'package:movie_app/core/services/movie_service.dart';

class MovieSectionController extends GetxController {
  var trendingMovies = <Result>[].obs;
  var popularMovies = <Result>[].obs;
  var upcomingMovies = <Result>[].obs;
  var koreanDramas = <Result>[].obs;

  var isLoading = true.obs;

  final _movieService = MovieService();

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    try {
      isLoading.value = true;
      trendingMovies.value = (await _movieService.fetchTrending()).results;
      popularMovies.value = (await _movieService.fetchMovies(
        'popular',
        1,
      )).results;
      upcomingMovies.value = (await _movieService.fetchMovies(
        'upcoming',
        1,
      )).results;
      koreanDramas.value = (await _movieService.fetchKoreanDrama()).results;
    } finally {
      isLoading.value = false;
    }
  }
}
