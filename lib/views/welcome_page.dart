import 'package:flutter/cupertino.dart';
// import 'package:hcaptcha/hcaptcha.dart';
import 'package:notes_app/views/login_page.dart';
import 'package:url_launcher/url_launcher.dart';

// Future<String?> showHCaptcha(BuildContext context) {
//   return showModalBottomSheet<String>(
//     context: context,
//     isScrollControlled: true,
//     builder: (_) => const SizedBox(height: 550, child: _HCaptchaView()),
//   );
// }

class WelcomePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar.large(
        automaticallyImplyLeading: false,
        largeTitle: Text("Get Started"),
      ),
      child: Column(
        spacing: 20,
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        children: [
          Row(
            mainAxisAlignment: .center,
            children: [
              SizedBox(
                width: MediaQuery.widthOf(context) / 1.25,
                child: Image.asset("assets/NoteDownText.png"),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18, bottom: 36),
            child: Row(
              children: [
                Text("● Open\n● Read - Write\n● Move"),
              ],
            ),
          ),
      
          CupertinoButton.filled(
            child: Text("Sign in to get started"),
            onPressed: () {
              showCupertinoSheet<void>(
                context: context,
                scrollableBuilder: (context, scrollController) {
                  return LoginPage();
                },
              );
            },
          ),
          Column(
            mainAxisAlignment: .end,
            children: [
              CupertinoButton(
                child: Text("Help / Feedback"),
                onPressed: () {
                  launchUrl(Uri.parse("https://t.me/AtherNiyargar"));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
