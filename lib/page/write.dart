import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../DB/sqlLite.dart';
import 'home.dart';
import 'view.dart';

class WritePage extends StatefulWidget {
  const WritePage({Key? key}) : super(key: key);

  @override
  _WritePageState createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  late userInfo userinfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    userinfo = userInfo(
      id: String2Sha256(DateTime.now().toString()),
      title: '제목 없음',
      answers: '[]',
      grade: '1',
      editedTime: DateTime.now().toString(),
      createTime: DateTime.now().toString(),
    );



    // SQLite sqLite = await SQLite.Instance();
  }

  String String2Sha256(String text) {
    var bytes = utf8.encode(text); // data being hashed
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  save(userInfo user) async {
    SQLite sqLite = await SQLite.Instance();
    await sqLite.insertTime(user);
  }

  ListToString(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('추가하기'),
      ),
      body: ListView(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'title',
            ),
            onChanged: (value) {
              userinfo.title = value;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'grade',
            ),
            onChanged: (value) {
              userinfo.grade = value;
            },

          ),
          CupertinoButton(
              child: Text('저장하기'),
              onPressed: () {
                save(userinfo);
              })
        ],
      ),
    );
  }
}
