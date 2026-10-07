import 'dart:io' show Directory;

import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class UnableToInsertOrUpdateException implements Exception {}

class UnableToDeleteException implements Exception {}

class UnableToAddFolderException implements Exception {}

class UnableToAddTaskException implements Exception {}

class UnableToUpdateFolderException implements Exception {}

class UnableToUpdateTaskException implements Exception {}

const String dbName = "notes_app.db";
const String notesTable = "notesTable";
const String _id = 'id';
const String _title = "title";
const String _content = "content";
const String _createdAt = "created_at";
const String _modifiedAt = "modified_at";
const String _pinned = "pinned";

const String _todoPageTable = "todo_pages";
const String _pageNameColumn = "page_name";

const String _todoTable = "todo_table";
const String _taskColumn = "task";
const String _isCompletedColumn = "is_completed";
const String _belongToColumn = "belong_to";
const String _toUploadColumn = "to_upload";
const String _toDeleteColumn = "to_delete";
const String _toDeletePageTable = "to_delete_page";

const String toDeletePageCreate =
    '''
  CREATE TABLE $_toDeletePageTable (
    $_pageNameColumn TEXT NOT NULL UNIQUE
  );
''';

const String todoFolderCreate =
    '''
  CREATE TABLE $_todoPageTable (
    $_pageNameColumn TEXT NOT NULL UNIQUE,
    $_toUploadColumn BOOL NOT NULL DEFAULT TRUE,
    $_toDeleteColumn BOOL NOT NULL DEFAULT FALSE
  );
''';

const String todoCreateQuery =
    '''
  CREATE TABLE $_todoTable (
    $_createdAt TEXT NOT NULL UNIQUE,
    $_taskColumn TEXT NOT NULL,
    $_isCompletedColumn BOOL NOT NULL DEFAULT 0,
    $_toUploadColumn BOOL NOT NULL DEFAULT TRUE,
    $_toDeleteColumn BOOL NOT NULL DEFAULT FALSE,
    $_belongToColumn TEXT NOT NULL,
    FOREIGN KEY ($_belongToColumn) REFERENCES $_todoPageTable ($_pageNameColumn) 
      ON DELETE CASCADE 
      ON UPDATE CASCADE
  );
''';

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
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON;');
      },
      onCreate: (db, version) async {
        await db.execute(createQuery);
        await db.execute(createToUploadTable);
        await db.execute(createToDeleteTable);

        await db.execute(todoFolderCreate);
        await db.execute(todoCreateQuery);
        await db.execute(toDeletePageCreate);
      },
    );
  }

  Future getDb() async {
    return _db ??= await openDb();
  }

  Future deleteAllPagesAndHenceAllTasks() async {
    Database db = await getDb();

    await db.delete(_todoPageTable);
  }

  Future nukePageTableWithData(List<Map<String, Object?>> data) async {
    Database db = await getDb();
    final batch = db.batch();
    for (var row in data) {
      batch.insert(_todoPageTable, row);
    }
    await batch.commit(noResult: true);
    await db.update(_todoPageTable, {_toUploadColumn: 0});
  }

  Future nukeTaskTableWithData(List<Map<String, Object?>> data) async {
    Database db = await getDb();
    final batch = db.batch();
    for (var row in data) {
      batch.insert(_todoTable, row);
    }
    await batch.commit(noResult: true);
    await db.update(_todoTable, {_toUploadColumn: 0});
  }

  Future getTasksToUpload() async {
    Database db = await getDb();
    return await db.query(
      _todoTable,
      where: "$_toDeleteColumn = ? AND $_toUploadColumn = ?",
      whereArgs: [0, 1],
      columns: [_createdAt, _taskColumn, _isCompletedColumn, _belongToColumn],
    );
  }

  Future getPagesToDelete() async {
    Database db = await getDb();
    return await db.query(_toDeletePageTable);
  }

  Future getPagesToUpload() async {
    Database db = await getDb();
    return await db.query(
      _todoPageTable,
      columns: [_pageNameColumn],
      where: "$_toUploadColumn = ? AND $_toDeleteColumn = ?",
      whereArgs: [1, 0],
    );
  }

  Future deletePage(String pageName) async {
    Database db = await getDb();
    await db.insert(_toDeletePageTable, {
      _pageNameColumn: pageName,
    }, conflictAlgorithm: .ignore);
    await db.delete(
      _todoPageTable,
      where: "$_pageNameColumn = ?",
      whereArgs: [pageName],
    );
  }

  Future<List<Map<String, Object?>>> fetchCompletedTask(String page) async {
    Database db = await getDb();
    return await db.query(
      _todoTable,
      // columns: [_taskColumn, _isCompletedColumn],
      where:
          "$_belongToColumn = ? AND $_isCompletedColumn = ? AND $_toDeleteColumn = ?",
      whereArgs: [page, 1, 0],
    );
  }

  Future<List<Map<String, Object?>>> fetchIncompletedTask(String page) async {
    Database db = await getDb();
    return await db.query(
      _todoTable,
      where:
          "$_belongToColumn = ? AND $_isCompletedColumn = ? AND $_toDeleteColumn = ?",
      whereArgs: [page, 0, 0],
    );
  }

  Future deleteTask(String createdAt) async {
    Database db = await getDb();
    await db.update(
      _todoTable,
      {_toDeleteColumn: 1},
      where: "$_createdAt = ?",
      whereArgs: [createdAt],
    );
  }

  Future getAllToDeleteTasks() async {
    Database db = await getDb();
    return await db.query(
      _todoTable,
      columns: [_createdAt],
      where: "$_toDeleteColumn = ?",
      whereArgs: [1],
    );
  }

  Future addTodoPage(String folderName) async {
    Database db = await getDb();
    // Can throw DatabaseException if folder name aleady exists.
    await db.insert(_todoPageTable, {_pageNameColumn: folderName});
  }

  Future editTask(String newTaskName, String createdAt) async {
    Database db = await getDb();
    await db.update(
      _todoTable,
      {_taskColumn: newTaskName, _toUploadColumn: 1},
      where: "$_createdAt = ?",
      whereArgs: [createdAt],
    );
  }

  Future updateTask(String createdAt, bool check) async {
    Database db = await getDb();
    await db.update(
      _todoTable,
      {_isCompletedColumn: check ? 1 : 0, _toUploadColumn: 1},
      where: "$_createdAt = ?",
      whereArgs: [createdAt],
    );
  }

  Future deleteAllTables() async {
    Database db = await getDb();
    await db.delete(_todoTable);
    await db.delete(_todoPageTable);
    await db.delete(_toDeletePageTable);

    await db.delete(notesTable);
    await db.delete(toDeleteTable);
    await db.delete(toUploadTable);
  }

  Future addTask(String task, String folderName) async {
    Database db = await getDb();
    final currentTime = DateTime.now().toUtc().toIso8601String();
    await db.insert(_todoTable, {
      _taskColumn: task,
      _createdAt: currentTime,
      _belongToColumn: folderName,
    });
  }

  Future updateTaskName(
    String createdAt,
    String newName,
    String folderName,
  ) async {
    Database db = await getDb();
    final result = await db.update(
      _todoTable,
      {_taskColumn: newName, _toUploadColumn: 1},
      where: "$_createdAt = ?",
      whereArgs: [createdAt],
    );
    if (result == 0) {
      throw UnableToUpdateTaskException();
    }
  }

  Future updatePageName(String oldName, String newName) async {
    Database db = await getDb();
    final result = await db.update(
      _todoPageTable,
      {_pageNameColumn: newName, _toUploadColumn: 1},
      where: "$_pageNameColumn = ?",
      whereArgs: [oldName],
    );

    if (result == 0) {
      throw UnableToUpdateFolderException();
    }

    // await db.update(
    //   _todoTable,
    //   {_pageNameColumn: newName},
    //   where: "$_pageNameColumn = ?",
    //   whereArgs: [oldName],
    // );
  }

  Future<List<Map<String, Object?>>> getAllTodoPage() async {
    Database db = await getDb();
    return await db.query(
      _todoPageTable,
      where: "$_toDeleteColumn = ?",
      whereArgs: [0],
    );
  }

  /* // This function is not used anywhere

  Future getAllTasks(String page) async {
    Database db = await getDb();
    return await db.query(
      _todoTable,
      where: "$_belongToColumn = ? AND $_toDeleteColumn = ?",
      whereArgs: [page, 0],
    );
  }*/

  Future<String> getTasksToShare(String page) async {
    Database db = await getDb();
    final buffer = StringBuffer();
    final tasks = await db.query(
      _todoTable,
      columns: [_isCompletedColumn, _taskColumn],
      where: "$_belongToColumn = ? AND $_toDeleteColumn = ?",
      whereArgs: [page, 0],
    );

    for (var row in tasks) {
      buffer.write(
        "\n${row[_isCompletedColumn] == 1 ? "✅" : "❌"} ${row[_taskColumn]}",
      );
    }
    return buffer.toString();
  }

  Future<int?> insertOrUpdateNote(
    int? sn,
    String? title,
    String? content,
    String? createdAt,
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
      where: "$_createdAt = ?",
      whereArgs: [createdAt],
    );

    if (result2 == 0) {
      final toInsertRow = await db.query(
        notesTable,
        columns: [_id, _title, _content, _createdAt, _modifiedAt, _pinned],
        where: "$_id = ?",
        whereArgs: [sn],
        limit: 1,
      );

      final result = await db.insert(toUploadTable, toInsertRow[0]);
      if (result == 0) {
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
    // print("========= ${await db.query(toUploadTable)}");
    return await db.query(
      toUploadTable,
      columns: [_title, _content, _createdAt, _modifiedAt, _pinned],
    );
  }

  Future nukeToDeleteTable() async {
    Database db = await getDb();
    await db.delete(toDeleteTable);
  }

  Future nukeToUploadNotes() async {
    Database db = await getDb();
    await db.delete(toUploadTable);
  }

  Future deleteAllNotes() async {
    Database db = await getDb();
    await db.delete(notesTable);
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    Database db = await getDb();
    return await db.query(notesTable);
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
    if (result != 1) throw UnableToDeleteException();

    result = await db.delete(
      toUploadTable,
      where: "$_createdAt = ?",
      whereArgs: [createdAt],
    );
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
