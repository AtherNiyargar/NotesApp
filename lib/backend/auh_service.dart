import 'package:flutter/cupertino.dart';
import 'package:notes_app/backend/supabase_client_service.dart';
import 'package:notes_app/elements/show_dialogs.dart' show showDialogs;
import 'package:supabase_flutter/supabase_flutter.dart';

class InvalidOtpException implements Exception {}

class AuthService {
  SupabaseClient? _supabase;
  SupabaseClient _getClient() {
    return _supabase ??= SupabaseClientService().getClient();
  }

  Future signUp(String email, String password, String captcha) async {
    final supabase = _getClient();
    await supabase.auth.signUp(
      email: email,
      password: password,
      captchaToken: captcha,
    );
  }

  Future verifyOtp(BuildContext context, String otp, String email) async {
    final supabase = _getClient();
    try {
      if (otp.isEmpty || otp.trim().length != 8) {
        throw InvalidOtpException();
      }
      AuthResponse authResp = await supabase.auth.verifyOTP(
        type: .signup,
        token: otp.trim(),
        email: email,
      );

      if (authResp.session != null && context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
      }
    } on InvalidOtpException {
      if (!context.mounted) return;
      await showDialogs(
        context,
        title: "Invalid OTP",
        content: "Please entered a valid OTP sent on your email.",
      );
    } on AuthRetryableFetchException {
      if (!context.mounted) return;
      await showDialogs(
        context,
        title: "Unable to connect to the server",
        content: "Please check your internet connection.",
      );
    } on AuthApiException catch (e) {
      if (e.code == "otp_expired") {
        if (!context.mounted) return;
        await showDialogs(
          context,
          title: "Invalid OTP",
          content: "The OTP enter is either invalid or expired.",
        );
      }
    }
  }

  Future signOut() async {
    await _getClient().auth.signOut();
  }

  Future loginWithPassword(
    String email,
    String password,
    String captchaToken,
  ) async {
    final supabase = _getClient();
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
      captchaToken: captchaToken,
    );
  }
}
