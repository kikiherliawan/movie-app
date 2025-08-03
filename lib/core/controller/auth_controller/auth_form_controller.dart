import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/core/controller/auth_controller/auth_controller.dart';

class AuthFormController extends GetxController {
  AuthFormController();

  late AuthController authController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void onInit() {
    super.onInit();

    authController = Get.find<AuthController>();

    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  onLoginButtonTapped() async {
    await authController.login(emailController.text, passwordController.text);

    if (authController.currentUser.value != null) {
      Get.back();
    }
  }

  onRegisterButtonTapped() async {
    await authController.register(
      emailController.text,
      passwordController.text,
    );

    if (authController.currentUser.value != null) {
      Get.back();
    }
  }
}
