import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/core/routes/app_routes.dart';
import 'package:movie_app/core/controller/auth_controller/auth_controller.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  late FocusNode _passwordFocusNode;
  late FocusNode _emailFocusNode;

  final RxBool obscurePassword = true.obs;

  late File _riveFile;
  late RiveWidgetController _riveWidgetController;
  late StateMachine _stateMachine;
  bool isRiveInitialized = false;

  @override
  void initState() {
    super.initState();
    _initRive();
  }

  Future<void> _initRive() async {
    _passwordFocusNode = FocusNode();
    _emailFocusNode = FocusNode();

    _passwordFocusNode.addListener(() {
      _updateHandsUpState();
    });

    _passwordFocusNode.addListener(() {
      _updateHandsUpState();
    });

    try {
      _riveFile = (await File.asset(
        'assets/animations/rive/bear_animated.riv',
        riveFactory: Factory.rive,
      ))!;

      _riveWidgetController = RiveWidgetController(
        _riveFile,
        stateMachineSelector: StateMachineSelector.byIndex(0),
      );

      _stateMachine = _riveWidgetController.stateMachine;

      setState(() => isRiveInitialized = true);

      final controller = Get.find<AuthController>();

      ever(controller.user, (user) {
        if (user != null && isRiveInitialized) {
          _stateMachine.trigger('trigSuccess')?.fire();

          Future.delayed(Duration(seconds: 2), () {
            if (mounted) {
              Get.toNamed(AppRoutes.MAIN);
            }
          });
        }
      });

      ever(controller.isLoading, (loading) {
        if (isRiveInitialized) {
          final checking = _stateMachine.boolean('isChecking');
          checking?.value = loading;
        }
      });
    } catch (e) {
      setState(() => isRiveInitialized = false);
    }
  }

  void _updateHandsUpState() {
    if (!isRiveInitialized) return;

    final handsUp = _stateMachine.boolean('isHandsUp');
    if (handsUp == null) return;

    bool shouldShowHandsUp =
        _passwordFocusNode.hasFocus && passwordController.text.isNotEmpty;

    handsUp.value = shouldShowHandsUp;
  }

  void _updateLookState(String text) {
    if (!isRiveInitialized) return;

    final numLook = _stateMachine.number('numLook');
    if (numLook != null) {
      double lookValue = (text.length * 10.0).clamp(0.0, 100.0);
      numLook.value = lookValue;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();

    if (isRiveInitialized) {
      _riveFile.dispose();
      _riveWidgetController.dispose();
      _stateMachine.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(title: Text("Login Screen")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isRiveInitialized)
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: RiveWidget(
                    controller: _riveWidgetController,
                    fit: Fit.contain,
                    layoutScaleFactor: 1 / 3,
                    hitTestBehavior: RiveHitTestBehavior.translucent,
                  ),
                )
              else
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Center(child: CircularProgressIndicator()),
                ),

              SizedBox(height: 16),

              TextField(
                controller: emailController,
                focusNode: _emailFocusNode,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: 16),

              TextField(
                controller: passwordController,
                focusNode: _passwordFocusNode,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                obscureText: true,
                onChanged: (text) {
                  _updateLookState(text);

                  _updateHandsUpState();
                },
              ),

              SizedBox(height: 32),

              Obx(() {
                final isLoading = controller.isLoading.value;

                return SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(10),
                      ),
                    ),
                    onPressed: isLoading
                        ? null
                        : () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            await Future.delayed(Duration(milliseconds: 100));
                            _updateHandsUpState();

                            if (emailController.text.isEmpty ||
                                passwordController.text.isEmpty) {
                              Get.snackbar("Error", "Please fill all fields");
                              if (isRiveInitialized) {
                                _stateMachine.trigger('trigFail')?.fire();
                              }
                              return;
                            }

                            if (!GetUtils.isEmail(
                              emailController.text.trim(),
                            )) {
                              Get.snackbar(
                                "Error",
                                "Please enter a valid email address",
                              );
                              if (isRiveInitialized) {
                                _stateMachine.trigger('trigFail')?.fire();
                              }
                              return;
                            }

                            try {
                              await controller.signIn(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );
                            } catch (e) {
                              if (isRiveInitialized) {
                                _stateMachine.trigger('trigFail')?.fire();
                              }
                            }
                          },
                    child: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.black,
                              ),
                            ),
                          )
                        : Text("Login"),
                  ),
                );
              }),
              SizedBox(height: 8),
              TextButton(
                onPressed: () => Get.toNamed(AppRoutes.REGISTER),
                child: Text("Not Have Account? Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
