import 'package:notes_app/backend/database_functionality.dart';
import 'package:notes_app/backend/supabase_client_service.dart';
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
          "page_name",
          List.generate(
            pageToDelete.length,
            (index) => pageToDelete[index]["page_name"],
          ),
        );
    final tasksToDelete = await databaseFunctionality!.getAllToDeleteTasks();
    await client!
        .from("todo")
        .delete()
        .inFilter(
          "created_at",
          List.generate(
            tasksToDelete.length,
            (index) => tasksToDelete[index]["created_at"],
          ),
        );
  }

  Future _uploadToServer() async {
    final pagesToUpload = await databaseFunctionality!.getPagesToUpload();
    try {
      await client!.from("todo_pages").upsert(pagesToUpload);
    } catch (_) {}

    final tasksToUpload = await databaseFunctionality!.getTasksToUpload();

    try {
      await client!
          .from("todo")
          .upsert(
            tasksToUpload
          );
    } catch (_) {}
  }

  Future _downloadPages() async {
    return await client!.from("todo_pages").select("page_name");
  }

  Future _downloadTasks() async {
    return await client!
        .from("todo")
        .select("created_at, task, is_completed, belong_to");
  }

  Future syncNotes() async {
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
}
