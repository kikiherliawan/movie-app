import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/core/controller/auth_controller/auth_controller.dart';
import 'package:movie_app/core/controller/movie_section_controller/movie_section_controller.dart';
import 'package:movie_app/core/widgets/movie_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<HomeScreen> {
  final authController = Get.find<AuthController>();
  final movieController = Get.find<MovieSectionController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1580489944761-15a19d654956?q=80&w=1361&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                        ),
                        radius: 24,
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: EdgeInsetsGeometry.only(left: 24)),
                          Obx(
                            () => Text(
                              'Hi, ${authController.username.value}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            "Let's watch a movies",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.notifications_none),
                  ),
                ],
              ),
            ),
            Expanded(
              child: MovieSection(
                title: 'Trending',
                movies: movieController.trendingMovies,
              ),
            ),
            Expanded(
              child: MovieSection(
                title: 'Populer',
                movies: movieController.popularMovies,
              ),
            ),
            Expanded(
              child: MovieSection(
                title: 'Korean Dramas',
                movies: movieController.koreanDramas,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
