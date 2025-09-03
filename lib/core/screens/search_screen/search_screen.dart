import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/core/controller/movie_list_controller/movie_list_controller.dart';
import 'package:movie_app/core/widgets/loader_overlay.dart';
import 'package:movie_app/core/widgets/movie_item.dart';

class MovieListScreen extends StatelessWidget {
  final movieListController = Get.put(MovieListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Movies")),
      body: Obx(() {
        if (movieListController.isLoading.value) {
          return Center(child: LoaderOverlay());
        }
        return Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: movieListController.searchMovies,
                decoration: InputDecoration(
                  hintText: "Search movies...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Expanded(child: MovieGridWidget()),
          ],
        );
      }),
    );
  }
}
