import 'package:flutter/cupertino.dart';
import 'package:notes_app/elements/show_dialogs.dart' show showDialogs;
import 'package:supabase_flutter/supabase_flutter.dart';

class InvalidOtpException implements Exception {}

class AuthService {
  SupabaseClient? _supabase;

  SupabaseClient getClient() => _supabase ??= Supabase.instance.client;

  Future signUp(String email, String password) async {
    final supabase = getClient();
    await supabase.auth.signUp(email: email, password: password);
  }

  Future verifyOtp(BuildContext context, String otp, String email) async {
    final supabase = getClient();
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
    await getClient().auth.signOut();
  }

  // Future signInWithOtp(String email) async {
  //   final supabase = getClient();
  //   await supabase.auth.signInWithOtp(email: email, shouldCreateUser: true);
  // }

  // Future verifyEmailOtp(BuildContext context, String otp, String email) async {
  //   final supabase = getClient();
  //   AuthResponse authResp = await supabase.auth.verifyOTP(
  //     type: .email,
  //     token: otp,
  //     email: email,
  //   );
  //   if (authResp.session != null && context.mounted) {
  //     Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
  //   }
  // }

  Future loginWithPassword(String email, String password) async {
    final supabase = getClient();
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
}
