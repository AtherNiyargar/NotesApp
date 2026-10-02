import 'dart:io' show Directory;

import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class UnableToInsertOrUpdateException implements Exception {}

class UnableToDeleteException implements Exception {}

const String dbName = "notes_app.db";
const String notesTable = "notesTable";
const String _id = 'id';
const String _title = "title";
const String _content = "content";
const String _createdAt = "created_at";
const String _modifiedAt = "modified_at";
const String _pinned = "pinned";

const String createQuery =
    '''
  CREATE TABLE $notesTable (
    $_id INTEGER NOT NULL UNIQUE,
    $_title TEXT,
    $_content TEXT,
    $_createdAt TEXT NOT NULL UNIQUE,
    $_modifiedAt TEXT NOT NULL UNIQUE,
    $_pinned TEXT UNIQUE,
    PRIMARY KEY ($_id AUTOINCREMENT)
  );
''';

const String toUploadTable = "toUploadTable";

const String createToUploadTable =
    '''
  CREATE TABLE $toUploadTable (
    $_id INTEGER NOT NULL UNIQUE,
    $_title TEXT,
    $_content TEXT,
    $_createdAt TEXT NOT NULL UNIQUE,
    $_modifiedAt TEXT NOT NULL UNIQUE,
    $_pinned TEXT UNIQUE,
    PRIMARY KEY ($_id AUTOINCREMENT)
  );
''';

const String toDeleteTable = "toDeleteTable";

const String createToDeleteTable =
    '''
  CREATE TABLE $toDeleteTable (
    $_createdAt TEXT NOT NULL UNIQUE
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
        await db.execute(createToUploadTable);
        await db.execute(createToDeleteTable);
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

    final currentTime = DateTime.now().toUtc().toIso8601String();

    final result1 = await db.update(
      notesTable,
      {_title: title, _content: content, _modifiedAt: currentTime},
      where: "$_id = ?",
      whereArgs: [sn],
    );

    if (result1 == 0) {
      throw UnableToInsertOrUpdateException();
    }

    final result2 = await db.update(
      toUploadTable,
      {_title: title, _content: content, _modifiedAt: currentTime},
      where: "$_id = ?",
      whereArgs: [sn],
    );

    if (result2 == 0) {
      final toInsertRow = await db.query(
        notesTable,
        columns: [_id, _title, _content, _createdAt, _modifiedAt],
        where: "$_id = ?",
        whereArgs: [sn],
        limit: 1,
      );

      final result = await db.insert(toUploadTable, toInsertRow[0]);
      if (result == 0) {
        // print("========= IAMHERE");
        throw UnableToInsertOrUpdateException();
      }
    }
    return null;
  }

  Future insertNote(String? title, String? content) async {
    Database db = await getDb();

    final currentTime = DateTime.now().toUtc().toIso8601String();

    final result1 = await db.insert(notesTable, {
      _title: title,
      _content: content,
      _createdAt: currentTime,
      _modifiedAt: currentTime,
    });

    final result2 = await db.insert(toUploadTable, {
      _title: title,
      _content: content,
      _createdAt: currentTime,
      _modifiedAt: currentTime,
    });

    if (result1 == 0 || result2 == 0) {
      throw UnableToInsertOrUpdateException();
    } else {
      return result1;
    }
  }

  Future getToUploadNotes() async {
    Database db = await getDb();
    return await db.query(
      toUploadTable,
      columns: [_title, _content, _createdAt, _modifiedAt, _pinned],
    );
  }

  Future nukeToUploadNotes() async {
    Database db = await getDb();
    await db.delete(toUploadTable);
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    Database db = await getDb();
    return await db.query(notesTable);
  }

  Future deleteAllNotes() async {
    Database db = await getDb();
    await db.delete(notesTable);
  }

  Future insertAllNotes(List<Map<String, dynamic>> downloadedNotes) async {
    Database db = await getDb();
    Batch batch = db.batch();
    for (var note in downloadedNotes) {
      batch.insert(notesTable, note, conflictAlgorithm: .replace);
    }
    await batch.commit(noResult: true);
  }

  Future deleteANote(String createdAt) async {
    Database db = await getDb();
    int result;
    result = await db.delete(
      notesTable,
      where: "$_createdAt = ?",
      whereArgs: [createdAt],
    );
    // if (result != 1) throw UnableToDeleteException();

    result = await db.delete(
      toUploadTable,
      where: "$_createdAt = ?",
      whereArgs: [createdAt],
    );
    // if (result != 1) throw UnableToDeleteException();

    await db.insert(toDeleteTable, {_createdAt: createdAt});
  }

  Future<List<Map<String, Object?>>> getAllToDeleteRows() async {
    Database db = await getDb();
    // print("============ -i am here");
    return await db.query(toDeleteTable);
  }

  Future pinOrUnpinNote(
    String? pinTime,
    String createdAt,
    Map<String, Object?> entry,
  ) async {
    Database db = await getDb();
    // print("========= $pinTime");
    await db.update(
      notesTable,
      {_pinned: pinTime},
      where: "$_createdAt = ?",
      whereArgs: [createdAt],
    );
    final result = await db.update(
      toUploadTable,
      {_pinned: pinTime},
      where: "$_createdAt = ?",
      whereArgs: [createdAt],
    );
    if (result != 1) {
      await db.insert(toUploadTable, entry);
    }
    // print("========= ${await db.query(toUploadTable)}");
  }
}
