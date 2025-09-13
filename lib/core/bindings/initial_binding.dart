import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:movie_app/core/controller/auth_controller/auth_controller.dart';
import 'package:movie_app/core/controller/bottom_nav_controller/buttom_nav_controller.dart';
import 'package:movie_app/core/controller/movie_detail_controller/movie_detail_controller.dart';
import 'package:movie_app/core/controller/movie_filter_controller/movie_filter_controller.dart';
import 'package:movie_app/core/controller/movie_list_controller/movie_list_controller.dart';
import 'package:movie_app/core/controller/movie_section_controller/movie_section_controller.dart';
import 'package:movie_app/core/controller/searc_controller/search_controller.dart';
import 'package:movie_app/core/network/dio_api_client.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    _initiateInstance();
    _initiateRepository();
    _initiateController();
  }

  void _initiateInstance() {
    Get.put<FirebaseAuth>(FirebaseAuth.instance);
  }

  void _initiateRepository() {}

  void _initiateController() {
    Get.put<AuthController>(AuthController());
    Get.put<BottomNavController>(BottomNavController());
    Get.lazyPut(() => MovieListController());
    Get.lazyPut(() => MovieSearchController());
    Get.lazyPut(() => MovieFilterController());
    Get.lazyPut(() => MovieDetailController(client: DioApiClient()));
    Get.put<MovieSectionController>(MovieSectionController());
  }
}
