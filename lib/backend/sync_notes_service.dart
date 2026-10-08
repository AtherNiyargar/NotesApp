import 'package:flutter/cupertino.dart';
import 'package:notes_app/backend/database_functionality.dart';
import 'package:notes_app/backend/supabase_client_service.dart';
import 'package:notes_app/globals.dart';
import 'package:notes_app/views/outdated_app_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SyncNotesService {
  // I need to ask ai if this pattern was even neccessary?
  SupabaseClient? client;
  DatabaseFunctionality? databaseFunctionality;
  SyncNotesService() {
    client = SupabaseClientService().getClient();
    databaseFunctionality = DatabaseFunctionality();
  }

  Future _downloadNotes() async => await client!
      .from("notes")
      .select("id, created_at, title, content, modified_at, pinned");

  Future _uploadNotes() async {
    final notesToUpload = await databaseFunctionality!.getNotesToUpload();
    // print("=============== $notesToUpload");
    await client!.from("notes").upsert(notesToUpload, onConflict: "created_at");
    await databaseFunctionality!.nukeToUploadNotes();
  }

  Future _deleteFromServer() async {
    final rowsToDelete = await databaseFunctionality!.getAllToDeleteNotes();
    await client!
        .from("notes")
        .delete()
        .inFilter(
          "created_at",
          List.generate(
            rowsToDelete.length,
            (index) => rowsToDelete[index]["created_at"],
          ),
        );
  }

  Future syncNotes(BuildContext context) async {
    if (!versionChecked) {
      try {
        final res = await client!.functions.invoke('getVersion');

        final latestVersion = (res.data as num).toDouble();

        if (latestVersion > appVersion) {
          var sp = await SharedPreferences.getInstance();
          await sp.setBool("isLatest", false);
          if (!context.mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(builder: (context) => OutdatedAppScreen()),
            (route) => false,
          );
        }
        versionChecked = true;
      } catch (_) {}
    }

    await _deleteFromServer();
    await _uploadNotes();
    final downloadedData = await _downloadNotes();
    await databaseFunctionality!.nukeNotesTablewithDownloadedNotes(
      downloadedData,
    );
  }
}
