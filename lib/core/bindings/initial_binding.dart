import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:movie_app/core/controller/auth_controller/auth_controller.dart';

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
    Get.put(AuthController(firebaseAuth: Get.find<FirebaseAuth>()));
  }
}
