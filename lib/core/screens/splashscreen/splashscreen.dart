import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/core/controller/splash_controller/splash_controller.dart';

class Splashscreen extends StatelessWidget {
  final SplashController controller = Get.put(SplashController());

  Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());

    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: controller.animation,
          builder: (context, child) {
            return Align(
              alignment: Alignment(0, controller.animation.value),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: controller.scaleAnimation.value,
                    height: controller.scaleAnimation.value,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/movies.png'),
                      ),
                    ),
                  ),
                  Text(
                    'Movies App',
                    style: TextStyle(
                      fontSize: controller.textAnimation.value,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
