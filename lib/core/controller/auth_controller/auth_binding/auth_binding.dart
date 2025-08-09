import 'package:get/get.dart';
import 'package:movie_app/core/controller/auth_controller/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
  }
}
