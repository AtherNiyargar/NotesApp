import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart' show launchUrl;

class OutdatedAppScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Center(
          child: Column(
            spacing: 20,
            mainAxisAlignment: .center,
            children: [
              Icon(CupertinoIcons.cloud_upload, size: 50),
              Text("An update is available!", style: TextStyle(fontSize: 24)),
              CupertinoButton.filled(
                child: Text("Download new version"),
                onPressed: () {
                  launchUrl(Uri.parse("https://notedownofficial.github.io"));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
