import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> getDb() async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await openDatabase(
        join(await getDatabasesPath(), "schedview.db"),
        onCreate: (db, version) async {
          await db.execute(
            'CREATE TABLE schedule_group (id INTEGER PRIMARY KEY, name TEXT);',
          );
          await db.execute("""
              CREATE TABLE schedule (
                id INTEGER PRIMARY KEY,
                group_id INTEGER,
                label TEXT,
                day TEXT,
                time_start VARCHAR(5),
                time_end VARCHAR(5),
                note TEXT,

                FOREIGN KEY (group_id) REFERENCES schedule_group(id) ON DELETE CASCADE
              );
            """);
        },
        version: 1,
      );

      await _db?.execute("PRAGMA foreign_keys = ON");
      return _db!;
    }
  }
}
