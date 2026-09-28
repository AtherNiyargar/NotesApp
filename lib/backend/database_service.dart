/*
// hcaptcha_auth.dart
// Needs in pubspec.yaml:
//   webview_flutter: ^4.0.0
//   supabase_flutter: ^2.0.0

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Use the test key while developing, then switch to your real site key.
const String hCaptchaSiteKey = '10000000-ffff-ffff-ffff-000000000001';

// Must be a domain added to your site in the hCaptcha dashboard
// (not needed for the test key).
const String hCaptchaBaseUrl = 'https://yourdomain.com';

/// Shows the captcha in a bottom sheet. Returns the token, or null if closed.
Future<String?> showHCaptcha(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const SizedBox(height: 550, child: _HCaptchaView()),
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
        sitekey: '$hCaptchaSiteKey',
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
      ..loadHtmlString(html, baseUrl: hCaptchaBaseUrl);
  }

  @override
  Widget build(BuildContext context) => WebViewWidget(controller: _controller);
}

// ---------------------------------------------------------------------------
// Supabase helpers. Call these from your buttons.
// ---------------------------------------------------------------------------

final _auth = Supabase.instance.client.auth;

Future<void> signInWithCaptcha(
  BuildContext context,
  String email,
  String password,
) async {
  final token = await showHCaptcha(context);
  if (token == null) return; // user closed the captcha

  try {
    await _auth.signInWithPassword(
      email: email,
      password: password,
      captchaToken: token,
    );
  } on AuthException catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
}

Future<void> signUpWithCaptcha(
  BuildContext context,
  String email,
  String password,
) async {
  final token = await showHCaptcha(context);
  if (token == null) return;

  try {
    await _auth.signUp(
      email: email,
      password: password,
      captchaToken: token,
    );
  } on AuthException catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
}

// Example usage in a button:
//
// ElevatedButton(
//   onPressed: () => signInWithCaptcha(context, emailCtrl.text, passCtrl.text),
//   child: const Text('Log in'),
// )
// */

import 'dart:io' show Directory;

import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class UnableToInsertOrUpdateException implements Exception {}

const String dbName = "notes_app.db";
const String tableName = "notesTable";
const String id = 'id';
const String _title = "title";
const String _content = "content";
// const String _dateCreated = "date_created";

const String createQuery =
    '''
  CREATE TABLE $tableName (
    $id INTEGER NOT NULL UNIQUE,
    $_title TEXT,
    $_content TEXT,
    PRIMARY KEY ($id AUTOINCREMENT)
  );
''';

class DatabaseService {
  DatabaseService._();

  static final DatabaseService _instance = DatabaseService._();

  factory DatabaseService() {
    return _instance;
  }

  Database? _db;

  Future openDb() async {
    Directory directory = await getApplicationSupportDirectory();
    String path = join(directory.path, dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(createQuery);
      },
    );
  }

  Future getDb() async {
    return _db ??= await openDb();
  }

  Future<int?> insertOrUpdateNote(
    int? sn,
    String? title,
    String? content,
  ) async {
    if (sn == null) {
      final id = await insertNote(title, content);
      if (id == 0) {
        throw UnableToInsertOrUpdateException();
      }
      return id;
    }
    Database db = await getDb();
    final result = await db.update(
      tableName,
      {id: sn, _title: title, _content: content},
      where: "$id = ?",
      whereArgs: [sn],
    );
    if (result == 0) {
      throw UnableToInsertOrUpdateException();
    }
    return null;
  }

  Future insertNote(String? title, String? content) async {
    Database db = await getDb();
    final result = await db.insert(tableName, {
      _title: title,
      _content: content,
    });
    if (result == 0) {
      throw UnableToInsertOrUpdateException();
    } else {
      return result;
    }
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    Database db = await getDb();
    return await db.query(tableName);
  }

  Future deleteAllNotes() async {
    Database db = await getDb();
    await db.delete(tableName);
  }
}
