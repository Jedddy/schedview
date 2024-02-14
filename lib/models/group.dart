import 'package:SchedView/database.dart';

class Group {
  final int id;
  final String name;

  const Group({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
    };
  }

  @override
  String toString() => "Group (id: $id, name: $name)";
}

void insertGroup(String name) async {
  final db = await DBHelper.getDb();

  await db.rawInsert('INSERT INTO "group" (name) VALUES (?)', [name]);
}

void deleteGroup(int id) async {
  final db = await DBHelper.getDb();

  await db.rawDelete('DELETE FROM "group" WHERE id = ?;', [id]);
}

Future<List<Group>> getGroups() async {
  final db = await DBHelper.getDb();
  final List<Map<String, dynamic>> result = await db.query("group");

  return result.map((group) {
    return Group(
      id: group["id"] as int,
      name: group["name"] as String
    );
  }).toList();
}
