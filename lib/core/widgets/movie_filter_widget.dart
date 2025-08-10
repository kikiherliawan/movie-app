import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/core/network/dio_api_client.dart';
import 'package:movie_app/core/response/movie_list_response.dart';

class MovieSearchFilterController extends GetxController {
  final DioApiClient _client = DioApiClient();

  var isLoading = false.obs;
  var results = <Result>[].obs;
  var errorMessage = ''.obs;

  var selectedGenreId = Rxn<int>();
  var selectedYear = Rxn<int>();
  var searchQuery = ''.obs;

  List<int> get years => List.generate(10, (i) => DateTime.now().year - i);

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) return;
    searchQuery.value = query;
    await _fetchMovies(endpoint: '/search/movie', params: {'query': query});
  }

  Future<void> _fetchMovies({
    required String endpoint,
    Map<String, dynamic>? params,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await _client.dio.get(endpoint, queryParameters: params);
      final movieList = MovieListResponse.fromJson(response.data);
      results.assignAll(movieList.results);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}

class MovieSearchFilterWidget extends StatelessWidget {
  MovieSearchFilterWidget({super.key});

  final controller = Get.put(MovieSearchFilterController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            labelText: 'Search movie...',
            prefixIcon: Icon(Icons.search),
          ),
          onSubmitted: (value) => controller.searchMovies(value),
        ),
        const SizedBox(height: 10),

        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.errorMessage.isNotEmpty) {
              return Center(child: Text('Error: ${controller.errorMessage}'));
            }
            if (controller.results.isEmpty) {
              return const Center(child: Text('No movies found.'));
            }

            return ListView.builder(
              itemCount: controller.results.length,
              itemBuilder: (context, index) {
                final movie = controller.results[index];
                return ListTile(
                  leading: Image.network(
                    'https://image.tmdb.org/t/p/w92${movie.posterPath}',
                    fit: BoxFit.cover,
                  ),
                  title: Text(movie.title),
                  subtitle: Text('Release: ${movie.releaseDate}'),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
