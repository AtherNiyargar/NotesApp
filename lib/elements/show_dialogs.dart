import 'package:flutter/cupertino.dart';
import 'package:notes_app/backend/auh_service.dart';

Future showOtpDialog(BuildContext context, String email) async {
  TextEditingController controller = TextEditingController();
  showCupertinoDialog(
    context: context,
    builder: (context) {
      AuthService authService = AuthService();
      return CupertinoAlertDialog(
        title: Column(
          spacing: 20,
          children: [
            Text("An OTP has been sent at $email.", style: .new(fontSize: 18)),
            Text(
              "The mail might be in the spam folder. If you don't recieve the email, then are probably already registered. You can simply log in.",
              style: TextStyle(fontWeight: .normal, fontSize: 16),
            ),
            CupertinoTextField(
              controller: controller,
              placeholder: "Enter OTP here",
            ),
          ],
        ),

        actions: [
          CupertinoDialogAction(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text("Submit"),
            onPressed: () {
              authService.verifyOtp(context, controller.text, email);
            },
          ),
        ],
      );
    },
  );
}

Future showDialogs(
  BuildContext context, {
  String? title,
  String? content,
}) async {
  // print("=============");
  showCupertinoDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: title != null ? Text(title, style: .new(fontSize: 18)) : null,

        content: content != null
            ? Text(content, style: .new(fontSize: 16))
            : null,
        actions: [
          CupertinoDialogAction(
            child: Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
    },
  );
}
