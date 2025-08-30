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

    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        final handsUp = _stateMachine.boolean('isHandsUp');
        handsUp?.value = false;
      } else {
        final handsUp = _stateMachine.boolean('isHandsUp');
        handsUp?.value = true;
      }
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
        }
      });

      ever(controller.isLoading, (loading) {
        if (isRiveInitialized) {
          final checking = _stateMachine.boolean('isChecking');
          checking?.value = loading;
        }
      });
    } catch (e) {
      print('Error loading Rive: $e');
      setState(() => isRiveInitialized = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _passwordFocusNode.dispose();

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
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                obscureText: true,
                onChanged: (text) {
                  if (isRiveInitialized) {
                    final numLook = _stateMachine.number('numLook');
                    if (numLook != null) {
                      double lookValue = (text.length * 10.0).clamp(0.0, 100.0);
                      numLook.value = lookValue;
                    }

                    final handsUp = _stateMachine.boolean('isHandsUp');
                    if (handsUp != null && _passwordFocusNode.hasFocus) {
                      handsUp.value = text.isNotEmpty;
                    }
                  }
                },
              ),

              SizedBox(height: 32),

              Obx(() {
                final isLoading = controller.isLoading.value;

                if (isRiveInitialized) {
                  final checking = _stateMachine.boolean('isChecking');
                  if (checking != null) {
                    checking.value = isLoading;
                  }
                }

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
                            bool isPasswordFieldFocused =
                                _passwordFocusNode.hasFocus;

                            if (isRiveInitialized) {
                              final handsUp = _stateMachine.boolean(
                                'isHandsUp',
                              );
                              if (handsUp != null) {
                                if (isPasswordFieldFocused) {
                                  handsUp.value = true;
                                } else {
                                  handsUp.value = false;
                                }
                              }
                            }

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
                              FocusManager.instance.primaryFocus?.unfocus();
                            } catch (e) {
                              //
                            }
                          },
                    child: Text("Login"),
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
