import 'package:flutter/cupertino.dart';
// import 'package:hcaptcha/hcaptcha.dart';
import 'package:notes_app/views/login_page.dart';

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
    // HCaptcha.init(siteKey: "160044e0-e92e-46c8-9b54-66be0f78cb64");
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar.large(
        automaticallyImplyLeading: false,
        largeTitle: Text("Welcome"),
      ),
      child: Center(
        child: CupertinoButton(
          child: Text("Login to get started"),
          onPressed: () {
            showCupertinoSheet<void>(
              // useNestedNavigation: nested,
              context: context,
              scrollableBuilder: (context, scrollController) {
                return LoginPage();
              },
            );
          },
        ),
      ),
    );
  }
}

/*
Container(
                  color: CupertinoColors.systemBackground.resolveFrom(context),
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: .end,
                          children: [
                            CupertinoButton(
                              child: Container(
                                padding: EdgeInsets.all(6),
                                alignment: .center,
                                decoration: BoxDecoration(
                                  shape: .circle,
                                  color: Colors.grey,
                                ),
                                child: Icon(
                                  CupertinoIcons.xmark,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(height: 100),
                              const Text('This is a Cupertino sheet'),
                              const SizedBox(height: 20),
                              CupertinoButton(
                                child: const Text('Close'),
                                onPressed: () {
                                  
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
*/
