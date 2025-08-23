import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/core/controller/auth_controller/auth_controller.dart';
import 'package:movie_app/core/screens/main/mainscreen.dart';
import 'package:movie_app/core/screens/sign_in_screen/sign_in.dart';

class AuthWrapper extends StatelessWidget {
  AuthWrapper({super.key});

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = authController.user.value;

      if (user == null) {
        return SignInScreen();
      } else {
        return MainScreen();
      }
    });
  }
}
