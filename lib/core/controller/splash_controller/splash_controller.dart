import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/core/routes/app_routes.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _textAnimation;

  Animation<double> get animation => _animation;
  Animation<double> get scaleAnimation => _scaleAnimation;
  Animation<double> get textAnimation => _textAnimation;

  @override
  void onInit() {
    super.onInit();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );

    _animation = Tween<double>(
      begin: -1,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));

    _scaleAnimation = Tween<double>(
      begin: 50,
      end: 200,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));

    _textAnimation = Tween<double>(
      begin: 0,
      end: 24,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));

    _startAnimation();
  }

  void _startAnimation() async {
    try {
      // Start animation
      await _controller.forward();

      // Wait a bit more after animation completes
      await Future.delayed(Duration(milliseconds: 500));

      // Stop animation before navigate
      _controller.stop();

      // Navigate
      Get.offAllNamed(AppRoutes.AUTHWRAPPER);
    } catch (e) {
      // Handle any animation errors
      print('Animation error: $e');
      Get.offAllNamed(AppRoutes.AUTHWRAPPER);
    }
  }

  @override
  void dispose() {
    if (_controller.isAnimating) {
      _controller.stop();
    }
    _controller.dispose();
    super.dispose();
  }
}
