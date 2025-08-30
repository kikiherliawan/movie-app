// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:rive/rive.dart';

// class LoginAnimationController extends GetxController {
//   static LoginAnimationController get instance => Get.find();
  
//   // Rive animation controllers
//   Artboard? riveArtboard;
//   late RiveWidgetController idleController;
//   late RiveWidgetController handsUpController;
//   late RiveWidgetController handsDownController;
//   late RiveWidgetController lookLeftController;
//   late RiveWidgetController lookRightController;
//   late RiveWidgetController successController;
//   late RiveWidgetController failController;
//   late RiveWidgetController loadingController;
  
//   // Animation states
//   final isLookingLeft = false.obs;
//   final isLookingRight = false.obs;
//   final isHandsUp = false.obs;
//   final isAnimationLoaded = false.obs;
  
//   @override
//   void onInit() {
//     super.onInit();
//     _initializeRive();
//   }
  
//   Future<void> _initializeRive() async {
//     try {
//       // Load Rive file
//       final data = await rootBundle.load('assets/rive/bear_animated.riv');
//       final file = RiveFile.import(data);
//       final artboard = file.mainArtboard;
      
//       // Initialize animation controllers
//       idleController = SimpleAnimation('idle');
//       handsUpController = SimpleAnimation('hands_up');
//       handsDownController = SimpleAnimation('hands_down');
//       lookLeftController = SimpleAnimation('look_left');
//       lookRightController = SimpleAnimation('look_right');
//       successController = SimpleAnimation('success');
//       failController = SimpleAnimation('fail');
//       loadingController = SimpleAnimation('loading'); // Optional loading animation
      
//       // Set initial animation
//       artboard.addController(idleController);
//       riveArtboard = artboard;
//       isAnimationLoaded.value = true;
      
//     } catch (e) {
//       print('Error loading Rive animation: $e');
//       isAnimationLoaded.value = false;
//     }
//   }
  
//   // Password field interaction
//   void onPasswordFocusStart() {
//     if (!isAnimationLoaded.value) return;
//     _playHandsUpAnimation();
//   }
  
//   void onPasswordFocusEnd() {
//     if (!isAnimationLoaded.value) return;
//     _playHandsDownAnimation();
//   }
  
//   void onPasswordChanged(String value) {
//     if (!isAnimationLoaded.value) return;
    
//     if (value.isNotEmpty && !isHandsUp.value) {
//       _playHandsUpAnimation();
//     } else if (value.isEmpty && isHandsUp.value) {
//       _playHandsDownAnimation();
//     }
//   }
  
//   // Email field interaction
//   void onEmailChanged(String value) {
//     if (!isAnimationLoaded.value) return;
    
//     // Character looks around based on email length
//     if (value.length > 15) {
//       lookRight();
//     } else if (value.length > 8) {
//       lookLeft();
//     } else {
//       resetLook();
//     }
//   }
  
//   void onEmailFocusEnd() {
//     if (!isAnimationLoaded.value) return;
//     resetLook();
//   }
  
//   // Authentication result animations
//   void playLoadingAnimation() {
//     if (!isAnimationLoaded.value) return;
//     _removeAllControllers();
//     riveArtboard?.addController(loadingController);
//   }
  
//   void playSuccessAnimation() {
//     if (!isAnimationLoaded.value) return;
//     _removeAllControllers();
//     riveArtboard?.addController(successController);
//   }
  
//   void playFailAnimation() {
//     if (!isAnimationLoaded.value) return;
//     _removeAllControllers();
//     riveArtboard?.addController(failController);
    
//     // Return to appropriate state after fail animation
//     Future.delayed(const Duration(seconds: 2), () {
//       if (isHandsUp.value) {
//         _playHandsUpAnimation();
//       } else {
//         resetToIdle();
//       }
//     });
//   }
  
//   void resetToIdle() {
//     if (!isAnimationLoaded.value) return;
//     isHandsUp.value = false;
//     isLookingLeft.value = false;
//     isLookingRight.value = false;
//     _removeAllControllers();
//     riveArtboard?.addController(idleController);
//   }
  
//   // Private animation methods
//   void _playHandsUpAnimation() {
//     isHandsUp.value = true;
//     _removeAllControllers();
//     riveArtboard?.addController(handsUpController);
//   }
  
//   void _playHandsDownAnimation() {
//     isHandsUp.value = false;
//     _removeAllControllers();
//     riveArtboard?.addController(handsDownController);
//   }
  
//   void lookLeft() {
//     if (!isLookingLeft.value) {
//       isLookingLeft.value = true;
//       isLookingRight.value = false;
//       _removeAllControllers();
//       riveArtboard?.addController(lookLeftController);
//     }
//   }
  
//   void lookRight() {
//     if (!isLookingRight.value) {
//       isLookingRight.value = true;
//       isLookingLeft.value = false;
//       _removeAllControllers();
//       riveArtboard?.addController(lookRightController);
//     }
//   }
  
//   void resetLook() {
//     isLookingLeft.value = false;
//     isLookingRight.value = false;
//     _removeAllControllers();
    
//     if (isHandsUp.value) {
//       riveArtboard?.addController(handsUpController);
//     } else {
//       riveArtboard?.addController(idleController);
//     }
//   }
  
//   void _removeAllControllers() {
//     riveArtboard?.removeController(idleController);
//     riveArtboard?.removeController(handsUpController);
//     riveArtboard?.removeController(handsDownController);
//     riveArtboard?.removeController(lookLeftController);
//     riveArtboard?.removeController(lookRightController);
//     riveArtboard?.removeController(successController);
//     riveArtboard?.removeController(failController);
//     riveArtboard?.removeController(loadingController);
//   }
// }