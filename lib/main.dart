import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:liquid_glass_widgets/liquid_glass_setup.dart';
import 'package:notes_app/views/create_or_edit_note.dart';
import 'package:notes_app/views/home_page.dart';
import 'package:notes_app/views/login_page.dart';
import 'package:notes_app/views/outdated_app_screen.dart';
import 'package:notes_app/views/signup_page.dart';
import 'package:notes_app/views/splash_screen.dart';
import 'package:notes_app/views/welcome_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LiquidGlassWidgets.initialize();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: CupertinoColors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  final sp = await SharedPreferences.getInstance();
  bool? isLatest = sp.getBool("isLatest");

  await dotenv.load();
  await Supabase.initialize(
    url: dotenv.get("URL"),
    publishableKey: dotenv.get("PUBLISHABLE_KEY"),
  );
  runApp(
    CupertinoApp(
      theme: CupertinoThemeData(),
      initialRoute: "/",
      routes: {
        "/": (_) {
          if (isLatest == false) {
            
            return const OutdatedAppScreen();
          } else {
            return const SplashScreen();
          }
        },
        "/welcome_page": (_) => const WelcomePage(),
        "/signup_page": (_) => SignupPage(),
        "/login_page": (_) => LoginPage(),
        "/home_page": (_) => HomePage(),
        "/create_note_page": (_) => CreateOrEditNotePage(),
      },
      debugShowCheckedModeBanner: false,
    ),
  );
}
