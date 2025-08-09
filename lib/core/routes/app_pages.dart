import 'package:get/get.dart';
import 'package:movie_app/core/routes/app_routes.dart';
import 'package:movie_app/core/screens/main/mainscreen.dart';
import 'package:movie_app/core/screens/movie_detail_screen/movie_detail_screen.dart';
import 'package:movie_app/core/screens/register_screen/register_screen.dart';
import 'package:movie_app/core/screens/sign_in_screen/sign_in.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.LOGIN, page: () => SignInScreen()),
    GetPage(name: AppRoutes.REGISTER, page: () => RegisterScreen()),
    GetPage(
      name: AppRoutes.MOVIEDETAIL,
      page: () {
        final movieId = Get.arguments as int;
        return MovieDetailScreen(movieId: movieId);
      },
    ),
    GetPage(name: AppRoutes.MAIN, page: () => MainScreen()),
  ];
}
