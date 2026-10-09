import 'package:flutter/cupertino.dart';
import 'package:notes_app/backend/database_service.dart';
import 'package:notes_app/backend/variables/notes.dart';
import 'package:notes_app/elements/show_dialogs.dart';
import 'package:uuid/uuid.dart';

class DatabaseFunctionality {
  late final DatabaseService _databaseService;
  late final Uuid uuid;

  DatabaseFunctionality() {
    uuid = const Uuid();
    _databaseService = DatabaseService();
  }
  Future getNotesToUpload() async {
    return await _databaseService.getToUploadNotes();
  }

  Future nukeToUploadNotes() async {
    await _databaseService.nukeToUploadNotes();
  }

  /*
  Future nukeDatabaseTables() async {
    await _databaseService.nukeToUploadNotes();
    await _databaseService.nukeToDeleteTable();
    await _databaseService.deleteAllNotes();
  }

*/
  Future insertOrUpdateNote(
    BuildContext context,
    int? id,
    String? title,
    String? content,
    String? createdAt,
  ) async {
    try {
      return await _databaseService.insertOrUpdateNote(
        id,
        title,
        content,
        createdAt,
      );
    } on UnableToInsertOrUpdateException {
      showDialogs(context, title: "Unable to save data");
    }
  }

  Future deletePage(String uid) async {
    await _databaseService.deletePage(uid);
  }

  Future addPage(String folderName) async {
    await _databaseService.addTodoPage(folderName, uuid.v4());
  }

  Future getAllToDeleteTasks() async {
    return _databaseService.getAllToDeleteTasks();
  }

  Future<List<Map<String, Object?>>> getAllPage() async {
    return await _databaseService.getAllTodoPage();
  }

  Future addTask(String task, String pageUid) async {
    await _databaseService.addTask(task, pageUid);
  }

  Future deleteATask(String taskId) async {
    await _databaseService.deleteTask(taskId);
  }

  Future getPagesToUpload() async {
    return await _databaseService.getPagesToUpload();
  }

  Future<List<Map<String, Object?>>> getPagesToDelete() async {
    return _databaseService.getPagesToDelete();
  }

  Future<List<Map<String, Object?>>> fetchCompletedTask(String pageUid) async {
    return _databaseService.fetchCompletedTask(pageUid);
  }

  Future<List<Map<String, Object?>>> fetchIncompletedTask(
    String pageUid,
  ) async {
    return _databaseService.fetchIncompletedTask(pageUid);
  }

  Future getTasksToUpload() async {
    return await _databaseService.getTasksToUpload();
  }

  Future deleteAllTables() async {
    await _databaseService.deleteAllTables();
  }

  // Future updateTaskName(
  //   BuildContext context,
  //   String oldName,
  //   String newName,
  //   String folderName,
  // ) async {
  //   try {
  //     await _databaseService.updateTaskName(oldName, newName, folderName);
  //   } catch (_) {
  //     if (!context.mounted) return;
  //     showDialogs(
  //       context,
  //       title: "Something went wrong",
  //       content: "Unable to update task.",
  //     );
  //   }
  // }

  Future updateTask(String taskId, bool check) async {
    await _databaseService.updateTask(taskId, check);
  }

  Future editTask(String newTaskName, String taskId) async {
    await _databaseService.editTask(newTaskName, taskId);
  }

  Future editPageName(
    BuildContext context,
    String newName,
    String pageId,
  ) async {
    try {
      await _databaseService.editPageName(newName, pageId);
    } catch (_) {
      if (!context.mounted) return;
      await showDialogs(
        context,
        title: "Something went wrong",
        content: "Unable to update page.",
      );
    }
  }

  Future deleteAllPagesAndHenceAllTasks() async {
    await _databaseService.deleteAllPagesAndHenceAllTasks();
  }

  Future nukePagesTableAndTasksTableWithData(
    List<Map<String, Object?>> pageData,
    List<Map<String, Object?>> tasksData,
  ) async {
    await _databaseService.nukePageTableWithData(pageData);
    await _databaseService.nukeTaskTableWithData(tasksData);
  }

  Future pinOrUnpinNote(
    String? pinTime,
    String createdAt,
    Map<String, Object?> entry,
  ) async {
    await _databaseService.pinOrUnpinNote(pinTime, createdAt, entry);
  }

  Future<void> populateNotes() async {
    notesData = (await _databaseService.getAllNotes()).toList();
  }

  Future _deleteAllNotes() async {
    await _databaseService.deleteAllNotes();
  }

  Future nukeNotesTablewithDownloadedNotes(
    List<Map<String, dynamic>> downloadedNotes,
  ) async {
    await _deleteAllNotes();
    await _databaseService.insertAllNotes(downloadedNotes);
  }

  Future deleteANote(String createdAt) async {
    await _databaseService.deleteANote(createdAt);
  }

  Future<List<Map<String, Object?>>> getAllToDeleteNotes() async {
    return await _databaseService.getAllToDeleteRows();
  }

  Future<String> getTasksToShare(String pageId) async {
    return await _databaseService.getTasksToShare(pageId);
  }
}
