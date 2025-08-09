import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/core/controller/movie_filter_controller/movie_filter_controller.dart';

class FilterButtonWidget extends StatelessWidget {
  final MovieFilterController filterController = Get.find();

  FilterButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        filterController.filterMovies(genreId: 28);
      },
      borderRadius: BorderRadius.circular(25),
      child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Icon(Icons.grid_view_rounded, color: Colors.grey),
      ),
    );
  }
}
