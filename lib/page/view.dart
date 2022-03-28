import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'edit.dart';

class ViewPage extends StatefulWidget {
  const ViewPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  List<userInfo> info = [];

  late Future<Database> database;

  Future start() async {
    print('start');
    await joinDatabase();

    await getInfo().then((value) => info = value);
    //insertTime();
    print(info);
  }

  Future joinDatabase() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'circle_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE circles(id TEXT PRIMARY KEY, title TEXT, answers TEXT, grade TEXT, createTime TEXT, editedTime TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<List<userInfo>> getInfo() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('circles');

    return List.generate(maps.length, (i) {
      return userInfo(
        id: maps[i]['id'],
        title: maps[i]['title'],
        answers: 'vvsa',
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

  @override
  void initState() {
    super.initState();
    start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          CupertinoButton(
              child: Text('새로고침'),
              onPressed: () {
                start();
              }),
          listSection()
        ],
      ),
    );
  }

  Widget listSection() {
    List<Widget> widgetList = [];
    int len = info.length;
    for (int i = 0; i < len; i++) {
      widgetList.add(unit(info[i]));
    }

    Widget widget = Column(
      children: widgetList,
    );

    return widget;
  }

  Widget unit(userInfo box) {
    print(box.toMap());

    Widget wi = Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      padding: const EdgeInsets.fromLTRB(18, 8, 8, 8),
      color: Colors.amberAccent,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                box.title,
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                width: 15,
              ),
              Container(
                  height: 30,
                  alignment: Alignment.bottomCenter,
                  //color: Colors.green,
                  child: Text(
                    box.id,
                    style: TextStyle(fontSize: 15),
                  )),
            ],
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '남은 시간: remaining',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    '완료 시간: completeTime',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );

    return wi;
  }
}

class userInfo {
  final String id;
  final String title;
  final String answers;
  final String grade;
  final String createTime;
  final String editedTime;


  userInfo({
    required this.id,
    required this.title,
    required this.answers,
    required this.grade,
    required this.createTime,
    required this.editedTime,
  });

  // dog를 Map으로 변환합니다. key는 데이터베이스 컬럼 명과 동일해야 합니다.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'answers': answers,
      'grade': grade,
      'createTime': createTime,
      'editedTime': editedTime,
    };
  }
}
