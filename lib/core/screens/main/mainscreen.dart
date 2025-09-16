import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/core/controller/bottom_nav_controller/buttom_nav_controller.dart';
import 'package:movie_app/core/screens/homescreen/home_screen.dart';
import 'package:movie_app/core/screens/rentscreen/rentscreen.dart';
import 'package:movie_app/core/screens/search_screen/search_screen.dart';
import 'package:movie_app/core/widgets/bottom_nav.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final List<Widget> pages = [
    HomeScreen(),
    MovieListScreen(),
    RentListScreen(firestore: FirebaseFirestore.instance),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BottomNavController>();

    return Obx(
      () => Scaffold(
        body: SafeArea(child: pages[controller.selectedIndex.value]),
        bottomNavigationBar: CustomBottomNav(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeIndex,
        ),
      ),
    );
  }
}
