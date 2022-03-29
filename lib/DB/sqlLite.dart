import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLite{

  late Future<Database> database;

  static Future<SQLite> Instance() async {
    SQLite sqLite=SQLite();
    sqLite.database= openDatabase(
      join(await getDatabasesPath(), 'circle_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE circles(id TEXT PRIMARY KEY, title TEXT, answers TEXT, grade TEXT, createTime TEXT, editedTime TEXT)",
        );
      },
      version: 1,
    );

    return sqLite;
  }
  String orderBy='editedTime DESC';

  Future<List<userInfo>> getInfo() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('circles',orderBy: orderBy);

    return List.generate(maps.length, (i) {
      return userInfo(
        id: maps[i]['id'],
        title: maps[i]['title'],
        answers: maps[i]['answers'],
        grade: maps[i]['grade'],
        createTime: maps[i]['createTime'],
        editedTime: maps[i]['editedTime'],
      );
    });
  }

  Future<void> deleteInfo(String id) async {
    // 데이터베이스 reference를 얻습니다.
    final db = await database;

    // 데이터베이스에서 Dog를 삭제합니다.
    await db.delete(
      'circles',
      // 특정 dog를 제거하기 위해 `where` 절을 사용하세요
      where: "id = ?",
      // Dog의 id를 where의 인자로 넘겨 SQL injection을 방지합니다.
      whereArgs: [id],
    );
  }

  Future<void> insertTime(userInfo time) async {
    print('추가됌');
    final Database db = await database;
    await db.insert(
      'circles',
      time.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

}

class userInfo {
  final String id;
  String title;
  String answers;
  String grade;
  String createTime;
  String editedTime;


  userInfo({
    required this.id,
    required this.title,
    required this.answers,
    required this.grade,
    required this.createTime,
    required this.editedTime,
  });

  List answerList(){
    List list= answers.split(',');
    list.removeAt(0);
    return list;
  }

  // dog를 Map으로 변환합니다. key는 데이터베이스 컬럼 명과 동일해야 합니다.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'grade': grade,
      'createTime': createTime,
      'editedTime': editedTime,
      'answers': answers,
    };
  }
}
