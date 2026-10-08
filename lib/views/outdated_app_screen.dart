import 'package:flutter/cupertino.dart';

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
              Icon(CupertinoIcons.cloud_upload, size: 50,),
              Text("An update is available!", style: TextStyle(fontSize: 24)),
              CupertinoButton.filled(child: Text("Download new version"), onPressed: () {})
            ],
          ),
        ),
      ),
    );
  }
}
