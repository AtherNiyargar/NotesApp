import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:notes_app/Exceptions/custom_exception.dart';
import 'package:notes_app/backend/auh_service.dart';
// import 'package:notes_app/backend/cupertino_sheet_workaround.dart';
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

      await authService.loginWithPassword(email, password);

      if (!context.mounted) return;
      // CupertinoSheetRoute.popSheet(context);
      Navigator.of(context).pop();

      // if (response != null) {
      //   Navigator.of(context).pushNamedAndRemoveUntil("/", (_) => false);
      // }

      // await client.auth.signInWithOtp(email: email, shouldCreateUser: false);

      // await showOtpDialog(context, email);
    } on InvalidEmailException {
      if (!context.mounted) return;
      await showDialogs(context, title: "Please enter a valid Gmail address");
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
          content: "Please check your credentials.",
        );
      }
    } catch (e) {
      print("========== ${e.toString()}");
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
    // if (!context.mounted) return;

    super.dispose();
  }

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
                  CupertinoTextField(
                    controller: _passwordController,
                    enabled: !logginIn,
                    placeholder: "Enter password",
                    obscureText: true,
                    keyboardType: .visiblePassword,
                  ),
                  CupertinoButton.filled(
                    minimumSize: Size(double.infinity, 0),
                    onPressed: logginIn
                        ? null
                        : () async {
                            await tryLogin(
                              setState,
                              context,
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                            // if (!context.mounted) return;
                            // Navigator.pop(context);
                            // await Future.delayed(Duration(seconds: 0));
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
                                  // useNestedNavigation: nested,
                                  context: context,
                                  scrollableBuilder:
                                      (context, scrollController) {
                                        return SignupPage();
                                      },
                                );

                                // Navigator.of(context).push(
                                //   CupertinoPageRoute(
                                //     builder: (context) => SignupPage(),
                                //   ),
                                // );
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
