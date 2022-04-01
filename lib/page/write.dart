import 'dart:convert';

import 'package:circle/tools/SrtingHandle.dart';
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
  List answers = ['', '', '', '', '', '', ''];
  int numline = 5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    userinfo = userInfo(
        id: StringHandle.String2Sha256(DateTime.now().toString()),
        title: '제목 없음',
        answers: '[]',
        grade: '1',
        editedTime: DateTime.now().toString(),
        createTime: DateTime.now().toString(),
        viewTime: DateTime.now().toString());

    // SQLite sqLite = await SQLite.Instance();
  }

  // 겹침
  save(userInfo user, BuildContext context) async {
    lastRemove(List list) {
      for (int i = 1; i <= list.length; i++) {
        if (list.last == '') {
          list.removeLast();
        } else {
          break;
        }
      }
      return list;
    }
    user.editedTime=DateTime.now().toString();
    print(answers);
    List list = lastRemove(answers);
    userinfo.answers = StringHandle.ListToString(list);

    SQLite sqLite = SQLite();
    await sqLite.insertTime(user);

    Navigator.of(context).pop(true);
  }
  addLine() {
    setState(() {
      numline = numline + 1;
      answers.add('');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('추가하기'),
        actions: [
          IconButton(
            onPressed: () {
              save(userinfo, context);
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: ListView(
        children: [
          CupertinoButton(
              child: Text('줄 추가하기 (현재 $numline 줄)'), onPressed: addLine),
          inputSection(),
        ],
      ),
    );
  }

  Widget inputSection() {
    List<Widget> list = [];
    for (int i = 1; i <= numline; i++) {
      list.add(inputWidget(i));
    }

    Widget widget = Column(
      children: [
        TextFormField(
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'title',
          ),
          onChanged: (value) {
            userinfo.title = value;
          },
        ),
        TextFormField(
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'grade',
          ),
          onChanged: (value) {
            userinfo.grade = value;
          },
        ),
        ...list
      ],
    );
    return widget;
  }

  Widget inputWidget(int num) {
    Color color = Colors.white;
    if (num % 10 > 5) {
      color = Colors.black12;
    } else if (num % 10 == 0) {
      color = Colors.black12;
    }

    Widget widget = Padding(
        padding: EdgeInsets.all(8),
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          decoration: BoxDecoration(
              color: color,
              border: Border.all(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.all(Radius.circular(300))),
          child: Row(
            children: [
              Text(
                '$num번: ',
                style: TextStyle(fontSize: 18),
              ),
              Expanded(
                  child: TextFormField(
                style: TextStyle(fontSize: 16),
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  answers[num - 1] = value;
                  print(answers);

                  if (numline == num) {
                    print('줄추가해');
                    addLine();
                  }

                },
              ))
            ],
          ),
        ));

    return widget;
  }



}
