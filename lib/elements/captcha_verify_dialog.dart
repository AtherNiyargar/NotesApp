import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

Future<String?> showCaptcha(BuildContext context) async {
  return showCupertinoDialog(
    context: context,
    builder: (_) => const Center(
      child: CupertinoPopupSurface(
        child: SizedBox(width: 340, height: 520, child: _HCaptchaView()),
      ),
    ),
  );
}

class _HCaptchaView extends StatefulWidget {
  const _HCaptchaView();

  @override
  State<_HCaptchaView> createState() => _HCaptchaViewState();
}

class _HCaptchaViewState extends State<_HCaptchaView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    const html = '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <script src="https://js.hcaptcha.com/1/api.js?onload=onLoad&render=explicit" async defer></script>
  <style>body{display:flex;justify-content:center;align-items:center;height:100vh;margin:0}</style>
</head>
<body>
  <div id="captcha"></div>
  <script>
    function onLoad() {
      hcaptcha.render('captcha', {
        sitekey: 'c2c2a706-a0b4-47c8-a32c-a4749dca8f7c',
        callback: function(token) { Captcha.postMessage(token); }
      });
    }
  </script>
</body>
</html>
''';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'Captcha',
        onMessageReceived: (msg) {
          if (msg.message.isNotEmpty && mounted) {
            Navigator.of(context).pop(msg.message);
          }
        },
      )
      ..loadHtmlString(
        html,
        baseUrl: "https://warm-beijinho-ab3838.netlify.app/",
      );
  }

  @override
  Widget build(BuildContext context) => WebViewWidget(controller: _controller);
}
