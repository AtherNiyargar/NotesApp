import 'package:flutter/cupertino.dart';
import 'package:notes_app/views/home_page.dart';
import 'package:notes_app/views/welcome_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session =
            snapshot.data?.session ??
            Supabase.instance.client.auth.currentSession;
        if (session != null) {
          return const HomePage();
        } else {
          return const WelcomePage();
        }
      },
    );
  }
}
