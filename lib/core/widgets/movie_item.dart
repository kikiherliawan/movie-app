import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/core/controller/movie_list_controller/movie_list_controller.dart';
import 'package:movie_app/core/network/dio_api_client.dart';
import 'package:movie_app/core/screens/movie_detail_screen/movie_detail_screen.dart';

class MovieGridWidget extends StatelessWidget {
  const MovieGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MovieListController>();
    final scrollController = ScrollController();

    // Listener buat detect scroll mentok bawah
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        controller.fetchMovies(); // load next page
      }
    });

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.movies.isEmpty) {
        return const Center(child: Text('No movies found'));
      }

      return Stack(
        children: [
          GridView.builder(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
              childAspectRatio: 0.6,
            ),
            itemCount: controller.movies.length,
            itemBuilder: (context, index) {
              final movie = controller.movies[index];
              return InkWell(
                onTap: () {
                  Get.to(() => MovieDetailScreen(movieId: movie.id));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        '$imageUrl${movie.posterPath}',
                        height: 130,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      movie.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      movie.releaseDate.year.toString(),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (movie.adult) // tampil cuma kalo true
                      const Text(
                        "Adult",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          if (controller.isLoadingMore.value)
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      );
    });
  }
}
