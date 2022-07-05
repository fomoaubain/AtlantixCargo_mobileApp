import 'package:qcabs_driver/model/dto/tourne.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class SqliteService {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'atlantixcargo.db'),
      onCreate: (database, version) async {
        await database.execute(
            "CREATE TABLE Tourne(id INTEGER PRIMARY KEY AUTOINCREMENT,  idTourne varchar, date_jour varchar, status int,  created varchar)",
        );
      },
      version : 1,
    );
  }

  Future<int> createItem(Tourne tourne) async {
    int result = 0;
    final Database db = await initializeDB();
    final id = await db.insert(
        'Tourne', tourne.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<Tourne?> getItems( var idTourne) async {
    final db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
    await db.query('Tourne', where:"idTourne = ? ", whereArgs: [idTourne]  );
    return queryResult.map((e) => Tourne.fromMap(e)).toList().first;
  }

   Future<void> updateItems( var idTourne, var val) async {
    final db = await initializeDB();
    await db.update('Tourne', {'status': val}, where: "idTourne = ? ", whereArgs: [idTourne]);
  }


}