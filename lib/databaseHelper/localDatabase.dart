// ignore_for_file: prefer_typing_uninitialized_variables, file_names

import 'package:get_it_done/utils/customLogs.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../modal/todoModal.dart';

class LocalDatabaseHelper {
  static var localDatabase;

  static connect() async {
    localDatabase = await openDatabase(
      'local_dataBase.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
    CREATE TABLE todos (
      id TEXT,
      title TEXT,
      description TEXT,
      isDone TEXT,
      date TEXT
    )
  ''');
      },
    );
    customLogs("dataBase is Created");
  }

  Future<bool> checkIfDatabaseExists() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'local_dataBase.db');
    return await databaseExists(path);
  }

  Future<int> insertTodo(TodoModal todo) async {
    int result = await localDatabase.insert(
      "todos",
      todo.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    customLogs(result);

    customLogs("Data is Inserted");

    return result;
  }

  getAllTodos() async {
    // final Database db = await database;
    final List<Map<String, dynamic>>? result =
        await localDatabase.query('todos');
    customLogs(result);

    List<TodoModal> listOfModal = [];

    for (var element in result!) {
      listOfModal.add(TodoModal.fromMap(element));
    }
    return listOfModal;
  }

  Future<void> deleteTodoById(String title) async {
    // final Database db = await database;
    await localDatabase.delete(
      'todos',
      where: 'title = ?',
      whereArgs: [title],
    );
  }

  // Future<User> getUserByEmail(String email) async {
  //   print("received email : $email");
  //   final List<Map<String, dynamic>> maps =
  //       await LocalDatabaseHelper.localDatabase.query(
  //     'user',
  //     where: 'email = ?',
  //     whereArgs: [email],
  //   );
  //   User user = User.fromJson(maps[0]);
  //   return User.fromJson(maps.first);
  // }

  // Future<User> getUserByUser(String username) async {
  //   final List<Map<String, dynamic>> maps =
  //       await LocalDatabaseHelper.localDatabase.query(
  //     'user',
  //     where: 'username = ?',
  //     whereArgs: [username],
  //   );
  //   User user = User.fromJson(maps[0]);
  //   return User.fromJson(maps.first);
  // }

  // Future<void> updateUserPassword(User user) async {
  // await LocalDatabaseHelper.localDatabase.update(
  //   'user',
  //   {
  //     'password': user.password,
  //     'updated_at': DateTime.now().toIso8601String(),
  //   },
  //   where: 'email = ?',
  //   whereArgs: [user.email],
  // );
  // }

  Future<void> printUsersTable() async {
    // final db = await database;
    final users = await localDatabase.query("todos");
    customLogs('Users table:');
    for (final user in users) {
      customLogs(user);
    }
  }

  updateTodo({String?title , TodoModal? todo}) async {
    // final db = await database; // Replace 'database' with your database instance
    // final id = await localDatabase.insert('todos', todo.toJson(),
    //     conflictAlgorithm: ConflictAlgorithm.replace);

    await localDatabase.update(
      'todos',
      todo!.toJson(),
      where: 'title = ?',
      whereArgs: [title],
      // conflictAlgorithm: ConflictAlgorithm.replace
    );
    // return id;
  }
}
