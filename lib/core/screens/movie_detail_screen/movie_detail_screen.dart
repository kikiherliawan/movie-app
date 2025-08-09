import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/core/controller/movie_detail_controller/movie_detail_controller.dart';
import 'package:movie_app/core/model/movie_order_response.dart';
import 'package:movie_app/core/network/dio_api_client.dart';
import 'package:movie_app/core/screens/rentscreen/orderscreeen/film_order_scren.dart';

class MovieDetailScreen extends StatelessWidget {
  final int movieId;

  MovieDetailScreen({required this.movieId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MovieDetailController());

    controller.fetchMovieDetail(movieId);

    return Scaffold(
      appBar: AppBar(title: Text("Movie Detail")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }
        if (controller.movieDetail.value == null) {
          return Center(child: Text("No data"));
        }

        final movie = controller.movieDetail.value!;
        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network('$imageUrl${movie.posterPath}'),
              SizedBox(height: 16),
              Text(
                movie.title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Release Date: ${movie.releaseDate.toString().split(' ')[0]}",
              ),
              SizedBox(height: 8),
              Text("Rating: ${movie.voteAverage}"),
              SizedBox(height: 16),
              Text(movie.overview),
              SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: movie.genres
                    .map((g) => Chip(label: Text(g.name)))
                    .toList(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final rentMovie = RentMovie(
                        id: movie.id,
                        title: movie.title,
                        posterPath: movie.posterPath,
                        releaseDate: movie.releaseDate,
                      );
                      Get.to(
                        () => FilmOrderScreen(movie: rentMovie.toResult()),
                      );
                    },
                    child: const Text('Sewa Film'),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
