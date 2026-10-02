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

  Future insertOrUpdateNote(
    BuildContext context,
    int? id,
    String? title,
    String? content,
  ) async {
    try {
      return await _databaseService.insertOrUpdateNote(id, title, content);
    } on UnableToInsertOrUpdateException {
      showDialogs(context, title: "Unable to save data");
    }
  }

  Future pinOrUnpinNote(
    String? pinTime,
    String createdAt,
    Map<String, Object?> entry,
  ) async {
    await _databaseService.pinOrUnpinNote(pinTime, createdAt, entry);
  }

  Future<void> populateNotes() async {
    notesData.clear();
    final result = await _databaseService.getAllNotes();
    // print("============ $result");
    final List<Map<String, dynamic>> unpinned = [];
    final List<Map<String, dynamic>> pinned = [];
    for (Map<String, dynamic> row in result) {
      if (row["pinned"] != null) {
        pinned.add(row);
      } else {
        unpinned.add(row);
      }
    }
    pinned.sort((b, a) => a["pinned"].compareTo(b["pinned"]));
    notesData = [...pinned, ...unpinned];
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
}
