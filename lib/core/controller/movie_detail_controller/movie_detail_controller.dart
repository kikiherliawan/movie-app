import 'package:get/get.dart';
import 'package:movie_app/core/network/dio_api_client.dart';
import 'package:movie_app/core/response/movie_detail_response.dart';

class MovieDetailController extends GetxController {
  final DioApiClient _client = DioApiClient();

  var isLoading = false.obs;
  var movieDetail = Rxn<MovieDetailResponse>();
  var errorMessage = ''.obs;

  Future<void> fetchMovieDetail(int movieId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _client.dio.get('/movie/$movieId');
      movieDetail.value = MovieDetailResponse.fromJson(response.data);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
