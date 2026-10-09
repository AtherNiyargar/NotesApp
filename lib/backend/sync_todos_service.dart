import 'package:flutter/cupertino.dart';
import 'package:notes_app/backend/database_functionality.dart';
import 'package:notes_app/backend/supabase_client_service.dart';
import 'package:notes_app/globals.dart';
import 'package:notes_app/views/outdated_app_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SyncTodosService {
  SupabaseClient? client;
  DatabaseFunctionality? databaseFunctionality;
  SyncTodosService() {
    client = SupabaseClientService().getClient();
    databaseFunctionality = DatabaseFunctionality();
  }

  Future _deleteFromServer() async {
    final pageToDelete = await databaseFunctionality!.getPagesToDelete();
    await client!
        .from("todo_pages")
        .delete()
        .inFilter(
          "unique_id",
          List.generate(
            pageToDelete.length,
            (index) => pageToDelete[index]["unique_id"],
          ),
        );
    final tasksToDelete = await databaseFunctionality!.getAllToDeleteTasks();
    await client!
        .from("todo")
        .delete()
        .inFilter(
          "task_id",
          List.generate(
            tasksToDelete.length,
            (index) => tasksToDelete[index]["task_id"],
          ),
        );
  }

  Future _uploadToServer() async {
    final pagesToUpload = await databaseFunctionality!.getPagesToUpload();
    try {
      await client!
          .from("todo_pages")
          .upsert(pagesToUpload, onConflict: "unique_id");
    } catch (_) {}

    final tasksToUpload = await databaseFunctionality!.getTasksToUpload();
    // print(tasksToUpload);

    try {
      await client!.from("todo").upsert(tasksToUpload, onConflict: "task_id");
    } catch (e) {
      // print(e.toString());
    }
  }

  Future _downloadPages() async {
    return await client!.from("todo_pages").select("page_name, unique_id");
  }

  Future _downloadTasks() async {
    return await client!
        .from("todo")
        .select("task_id, task, is_completed, belong_to");
  }

  Future syncTodos(BuildContext context) async {

    


    if (!versionChecked) {
      try {
        final res = await client!.functions.invoke('getVersion');

        final latestVersion = (res.data as num).toDouble();

        if (latestVersion > appVersion) {
          var sp = await SharedPreferences.getInstance();
          await sp.setBool("isLatest", false);
          if (!context.mounted) return;
          await Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(builder: (context) => OutdatedAppScreen()),
            (route) => false,
          );
        }
        versionChecked = true;
      } catch (_) {}
    }




    await _deleteFromServer();
    await _uploadToServer();

    await databaseFunctionality!.deleteAllPagesAndHenceAllTasks();
    final downloadedPages = await _downloadPages();
    final downloadedTasks = await _downloadTasks();

    await databaseFunctionality!.nukePagesTableAndTasksTableWithData(
      downloadedPages,
      downloadedTasks,
    );
  }

  Future refresAppDataFromServer() async {
    await databaseFunctionality!.deleteAllPagesAndHenceAllTasks();
    final downloadedPages = await _downloadPages();
    final downloadedTasks = await _downloadTasks();
    await databaseFunctionality!.nukePagesTableAndTasksTableWithData(
      downloadedPages,
      downloadedTasks,
    );
  }
}
