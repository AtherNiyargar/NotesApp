import 'dart:io' show SocketException;

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    show InternetConnection;
import 'package:notes_app/Exceptions/custom_exception.dart';
import 'package:notes_app/backend/auh_service.dart';
import 'package:notes_app/elements/captcha_verify_dialog.dart';
import 'package:notes_app/elements/show_dialogs.dart';
import 'package:notes_app/views/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show AuthRetryableFetchException, AuthWeakPasswordException;

class SignupPage extends StatefulWidget {
  const new({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool logginIn = false;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  AuthService authService = .new();

  Future<void> trySignUp(
    void Function(VoidCallback) setState,
    BuildContext context,
    String email,
    String password,
    String confirmPassword,
  ) async {
    setState(() {
      logginIn = true;
    });

    try {
      if (!EmailValidator.validate(email) || !email.endsWith("@gmail.com")) {
        throw InvalidEmailException();
      }
      if (password != confirmPassword) {
        await showDialogs(context, title: "Passwords do not match");
        return;
      }
      if (password.isEmpty || confirmPassword.isEmpty) {
        await showDialogs(context, title: "Passwords enter the password field");
        return;
      }
      final RegExp passwordRegex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[^a-zA-Z0-9\s]).{8,72}$',
      );
      if (!passwordRegex.hasMatch(password)) {
        await showDialogs(
          context,
          title: "Password is weak",
          content: "Password must be greater than 8 characters, and contain uppercase and lowercase letter, numbers and special symbols.",
        );
        return;
      }

      final result = await InternetConnection().hasInternetAccess;

      if (!result) {
        throw SocketException("Please check your internet");
      }

      if (!context.mounted) return;

      final captcha = await showCaptcha(context);
      if (captcha == null) return;

      await authService.signUp(email, password, captcha);

      if (!context.mounted) return;
      await showOtpDialog(context, email);
    } on AuthWeakPasswordException {
      if (!context.mounted) return;
      await showDialogs(
        context,
        title: "Password is weak",
        content: "Password must be greater than 8 characters, and contain uppercase and lowercase letter, numbers and special symbols.",
      );
    } on SocketException {
      if (!context.mounted) return;
      await showDialogs(
        context,
        title: "Unable to login",
        content: "Please check your internet connection.",
      );
    } on InvalidEmailException {
      if (!context.mounted) return;
      await showDialogs(
        context,
        title: "Invalid email",
        content: "Please enter a valid Gmail address.",
      );
    } on AuthRetryableFetchException {
      if (!context.mounted) return;
      await showDialogs(
        context,
        title: "Unable to connect to the server",
        content: "Please check your internet connection.",
      );
    } catch (e) {
      if (!context.mounted) return;
      await showDialogs(context, title: "Error occured: ${e.toString()}");
    } finally {
      setState(() {
        logginIn = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: SingleChildScrollView(
        child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar.large(
            largeTitle: Text("Sign up"),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                spacing: 25,
                children: [
                  Icon(CupertinoIcons.person_2_fill, size: 128),
                  CupertinoTextField(
                    controller: _emailController,
                    enabled: !logginIn,
                    placeholder: "Enter email",
                    // decoration: BoxDecoration(
                    //   color: CupertinoColors.secondarySystemBackground,
                    //   borderRadius: BorderRadius.circular(7),
                    // ),
                    // padding: EdgeInsetsGeometry.all(15),
                    keyboardType: .emailAddress,
                  ),
                  CupertinoTextField(
                    controller: _passwordController,
                    enabled: !logginIn,
                    placeholder: "Enter password",
                    // decoration: BoxDecoration(
                    //   color: CupertinoColors.secondarySystemBackground,
                    //   borderRadius: BorderRadius.circular(7),
                    // ),
                    // padding: EdgeInsetsGeometry.all(15),
                    obscureText: true,
                    keyboardType: .visiblePassword,
                  ),
                  Column(
                    crossAxisAlignment: .end,
                    children: [
                      CupertinoTextField(
                        controller: _confirmPasswordController,
                        enabled: !logginIn,
                        placeholder: "Confirm password",
                        // decoration: BoxDecoration(
                        //   color: CupertinoColors.secondarySystemBackground,
                        //   borderRadius: BorderRadius.circular(7),
                        // ),
                        // padding: EdgeInsetsGeometry.all(15),
                        obscureText: hidePassword,
                        keyboardType: .visiblePassword,
                      ),
                      CupertinoButton(
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        child: Icon(
                          hidePassword
                              ? CupertinoIcons.eye
                              : CupertinoIcons.eye_slash,
                        ),
                      ),
                    ],
                  ),
                  CupertinoButton.filled(
                    minimumSize: Size(double.infinity, 0),
                    onPressed: logginIn
                        ? null
                        : () => trySignUp(
                            setState,
                            context,
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                            _confirmPasswordController.text.trim(),
                          ),
                    child: logginIn
                        ? CupertinoActivityIndicator()
                        : Text("Sign up"),
                  ),
                  Row(
                    spacing: 5,
                    mainAxisAlignment: .center,
                    children: [
                      Text("Already have an account?"),
                      GestureDetector(
                        onTap: logginIn
                            ? null
                            : () {
                                Navigator.of(context).pop();
                                showCupertinoSheet<void>(
                                  context: context,
                                  scrollableBuilder:
                                      (context, scrollController) {
                                        return LoginPage();
                                      },
                                );
                              },
                        child: Text(
                          "Log in here",
                          style: TextStyle(color: CupertinoColors.activeBlue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
