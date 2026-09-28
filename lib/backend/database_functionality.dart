import 'package:flutter/cupertino.dart';
import 'package:notes_app/backend/database_service.dart';
import 'package:notes_app/backend/variables/notes.dart';
import 'package:notes_app/elements/show_dialogs.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseFunctionality {
  late final DatabaseService _databaseService;

  DatabaseFunctionality() {
    _databaseService = DatabaseService();
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

  Future populateNotes(BuildContext context) async {
    try {
      notesData.clear();
      // await Future.delayed(Duration(seconds: 5));
      final result = await _databaseService.getAllNotes();
      for (Map<String, dynamic> row in result) {
        notesData.add(row);
      }
    } on DatabaseException {
      if (!context.mounted) return;
      showDialogs(context, title: "Failed to get notes. Pleaase try again");
    }
  }

  Future deleteAllNotes() async {
    await _databaseService.deleteAllNotes();
  }
}
