import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/core/widgets/loader_overlay.dart';

class AuthController extends GetxController {
  final FirebaseAuth firebaseAuth;
  AuthController({required this.firebaseAuth});

  @override
  void onInit() {
    super.onInit();
    currentUser.value = firebaseAuth.currentUser;
  }

  final currentUser = Rxn<User>(null);

  Future<void> login(String email, String password) async {
    await Get.showOverlay(
      asyncFunction: () async {
        try {
          await firebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
        } on FirebaseAuthException catch (e) {
          Get.snackbar("Error Login", e.message.toString());
        } finally {
          currentUser.value = firebaseAuth.currentUser;
        }
      },
      loadingWidget: LoaderOverlay(),
    );
  }

  Future<void> register(String email, String password) async {
    await Get.showOverlay(
      asyncFunction: () async {
        try {
          await firebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
        } on FirebaseAuthException catch (e) {
          Get.snackbar("Error Register", e.message.toString());
        } finally {
          currentUser.value = firebaseAuth.currentUser;
        }
      },
      loadingWidget: LoaderOverlay(),
    );
  }

  Future<void> logout() async {
    await Get.showOverlay(
      asyncFunction: () async {
        try {
          await firebaseAuth.signOut();
        } on FirebaseAuthException catch (e) {
          Get.snackbar("Error Register", e.message.toString());
        } finally {
          currentUser.value = firebaseAuth.currentUser;
        }
      },
      loadingWidget: LoaderOverlay(),
    );
  }
}
