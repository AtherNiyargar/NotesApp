import 'dart:io' show SocketException;
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    show InternetConnection;
import 'package:notes_app/Exceptions/custom_exception.dart';
import 'package:notes_app/backend/auh_service.dart';
import 'package:notes_app/elements/captcha_verify_dialog.dart';
import 'package:notes_app/elements/show_dialogs.dart';
import 'package:notes_app/views/signup_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show AuthApiException, AuthRetryableFetchException;

class LoginPage extends StatefulWidget {
  const new({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  AuthService authService = .new();

  bool logginIn = false;

  Future<void> tryLogin(
    void Function(VoidCallback) setState,
    BuildContext context,
    String email,
    String password,
  ) async {
    setState(() {
      logginIn = true;
    });

    try {
      if (!EmailValidator.validate(email) || !email.endsWith("@gmail.com")) {
        throw InvalidEmailException();
      }

      if (password.isEmpty) {
        await showDialogs(context, title: "Please enter a password");
        return;
      }

      final result = await InternetConnection().hasInternetAccess;

      if (!result) {
        throw SocketException("Please check your internet");
      }

      if (!context.mounted) return;
      final captcha = await showCaptcha(context);
      if (captcha == null) return;

      await authService.loginWithPassword(email, password, captcha);

      if (!context.mounted) return;

      Navigator.of(context).pop();
    } on InvalidEmailException {
      if (!context.mounted) return;
      await showDialogs(context, title: "Please enter a valid Gmail address");
    } on SocketException {
      if (!context.mounted) return;
      await showDialogs(
        context,
        title: "Unable to login",
        content: "Please check your internet connection.",
      );
    } on AuthRetryableFetchException {
      if (!context.mounted) return;
      await showDialogs(
        context,
        title: "Unable to connect to the server",
        content: "Please check your internet connection.",
      );
    } on AuthApiException catch (e) {
      if (!context.mounted) return;
      if (e.code == "invalid_credentials") {
        await showDialogs(
          context,
          title: "Unable to login",
          content: "Please check the email id or password.",
        );
      }
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
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
            largeTitle: Text("Log in"),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                spacing: 25,
                children: [
                  Icon(CupertinoIcons.person_fill, size: 128),
                  CupertinoTextField(
                    controller: _emailController,
                    enabled: !logginIn,
                    placeholder: "Enter email",
                    keyboardType: .emailAddress,
                  ),

                  Column(
                    crossAxisAlignment: .end,
                    children: [
                      CupertinoTextField(
                        controller: _passwordController,
                        enabled: !logginIn,
                        placeholder: "Enter password",
                        obscureText: hidePassword,
                        keyboardType: .visiblePassword,
                        // suffix:
                        // suffixMode: .editing,
                        // suffix: Icon(CupertinoIcons.eye_fill),
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
                        : () async {
                            if (!context.mounted) return;

                            await tryLogin(
                              setState,
                              context,
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                          },
                    child: logginIn
                        ? CupertinoActivityIndicator()
                        : Text("Log in"),
                  ),
                  Row(
                    spacing: 5,
                    mainAxisAlignment: .center,
                    children: [
                      Text("Don't have an account?"),
                      GestureDetector(
                        onTap: logginIn
                            ? null
                            : () {
                                Navigator.of(context).pop();
                                showCupertinoSheet<void>(
                                  context: context,
                                  scrollableBuilder:
                                      (context, scrollController) {
                                        return SignupPage();
                                      },
                                );
                              },
                        child: Text(
                          "Create one",
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
