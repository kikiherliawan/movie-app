import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/core/routes/app_routes.dart';
import 'package:movie_app/core/services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  var isLoading = false.obs;
  Rxn<User> user = Rxn<User>();
  RxString username = ''.obs;

  @override
  void onInit() {
    user.bindStream(_authService.authStateChanges);
    ever(user, _setInitialScreen);
    super.onInit();
  }

  @override
  void onClose() {}

  void _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAllNamed(AppRoutes.LOGIN);
    } else {
      fetchUsername();
      Get.offAllNamed(AppRoutes.MAIN);
    }
  }

  Future<void> fetchUsername() async {
    final uid = _authService.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .get();
      if (doc.exists) {
        username.value = doc.data()?['username'] ?? '';
      }
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      await _authService.signIn(email, password);
    } catch (e) {
      Get.snackbar("Error SignIn", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String username, String email, String password) async {
    try {
      isLoading.value = true;
      final user = await _authService.register(email, password);

      if (user != null) {
        await FirebaseFirestore.instance.collection('user').doc(user.uid).set({
          'username': username,
          'email': email,
          'createAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      Get.snackbar("Error Register", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
  }
}
