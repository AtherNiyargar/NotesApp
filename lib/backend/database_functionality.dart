import 'package:flutter/cupertino.dart';
import 'package:notes_app/backend/database_service.dart';
import 'package:notes_app/backend/variables/notes.dart';
import 'package:notes_app/elements/show_dialogs.dart';

class DatabaseFunctionality {
  late final DatabaseService _databaseService;

  DatabaseFunctionality() {
    _databaseService = DatabaseService();
  }

  Future getNotesToUpload() async {
    return await _databaseService.getToUploadNotes();
  }

  Future nukeToUploadNotes() async {
    await _databaseService.nukeToUploadNotes();
  }

  Future nukeDatabaseTables() async {
    await _databaseService.nukeToUploadNotes();
    await _databaseService.nukeToDeleteTable();
    await _databaseService.deleteAllNotes();
  }

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

  Future deletePage(String pageName) async {
    await _databaseService.deletePage(pageName);
  }

  Future deleteATask(String createdAt) async {
    await _databaseService.deleteTask(createdAt);
  }

  Future addPage(String folderName) async {
    await _databaseService.addTodoPage(folderName);
  }

  Future getAllToDeleteTasks() async {
    return _databaseService.getAllToDeleteTasks();
  }

  Future<List<Map<String, Object?>>> getAllPage() async {
    return await _databaseService.getAllTodoPage();
  }

  Future addTask(String task, String folderName) async {
    await _databaseService.addTask(task, folderName);
  }

  Future getPagesToUpload() async {
    return await _databaseService.getPagesToUpload();
  }

  Future getPagesToDelete() async {
    return _databaseService.getPagesToDelete();
  }

  Future<List<Map<String, Object?>>> fetchCompletedTask(String page) async {
    return _databaseService.fetchCompletedTask(page);
  }

  Future<List<Map<String, Object?>>> fetchIncompletedTask(String page) async {
    return _databaseService.fetchIncompletedTask(page);
  }

  Future getTasksToUpload() async {
    return await _databaseService.getTasksToUpload();
  }

  Future deleteAllTables()async {
    await _databaseService.deleteAllTables();
  }

  Future updateTaskName(
    BuildContext context,
    String oldName,
    String newName,
    String folderName,
  ) async {
    try {
      await _databaseService.updateTaskName(oldName, newName, folderName);
    } catch (_) {
      if (!context.mounted) return;
      showDialogs(
        context,
        title: "Something went wrong",
        content: "Unable to update task.",
      );
    }
  }

  Future updateTask(String createdAt, bool check) async {
    await _databaseService.updateTask(createdAt, check);
  }

  Future editTask(String newTaskName, String createdAt) async {
    await _databaseService.editTask(newTaskName, createdAt);
  }

  Future updateFolderName(
    BuildContext context,
    String oldName,
    String newName,
  ) async {
    try {
      await _databaseService.updatePageName(oldName, newName);
    } on UnableToUpdateFolderException {
      if (!context.mounted) return;
      showDialogs(
        context,
        title: "Cannot update folder name",
        content: "The folder with this name may already exist.",
      );
    } catch (_) {
      if (!context.mounted) return;
      showDialogs(
        context,
        title: "Something went wrong",
        content: "Unable to insert task.",
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

  Future<String> getTasksToShare(String page) async {
    return await _databaseService.getTasksToShare(page);
  }
}
