import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'home.dart';
import 'view.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key, required this.userinfo}) : super(key: key);
  final userInfo userinfo;

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late final Future<Database> database;
  late userInfo userinfo = widget.userinfo;

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

  Future<void> insertTime(userInfo time) async {
    print('추가됌');
    final Database db = await database;
    await db.insert(
      'circles',
      time.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() {
    joinDatabase();
  }

  save() async{
    //userinfo.answerList = [];
    await insertTime(userinfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('추가하기'),
      ),
      body: ListView(
        children: [
          Text('text'),
          TextFormField(
            initialValue: 'teeee',
            decoration: InputDecoration(
              labelText: 'title',
            ),
            onChanged: (value) {
              userinfo.title=value;
            },
          ),
          Text(widget.userinfo.id),
          Text(widget.userinfo.answers),
          CupertinoButton(
              child: Text('저장하기'),
              onPressed: () {
                save();
              })
        ],
      ),
    );
  }
}
