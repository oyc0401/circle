import 'dart:math';

import 'package:circle/DB/sqlLite.dart';
import 'package:circle/page/home.dart';
import 'package:circle/page/write.dart';
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
  List<userInfo> list = [];
  SQLite sqLite = SQLite();

  @override
  void initState() {
    super.initState();
    init();
  }

  delete(String id) async {
    sqLite.deleteInfo(id);
  }

  init() async {
    print('init');
    list = await sqLite.getInfo();
    setState(() {});
  }

  _navigateEditPage(BuildContext context, userInfo user) async {
    await Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => EditPage(userinfo: user)),
    );

    print('back');
    init();
  }

  _navigateWritePage(BuildContext context) async {
    await Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => WritePage()),
    );
    print('back');
    init();
  }

  _navigateHomePage(BuildContext context, userInfo user) async {
    await Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => MyHomePage(userinfo: user)),
    );
    print('back');
    init();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              _navigateWritePage(context);
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: ListView(
        children: [
          // CupertinoButton(
          //     child: Text('새로고침'),
          //     onPressed: () {
          //       init();
          //     }),
          orderBySection(),
          listSection(context)
        ],
      ),
    );
  }

  Widget orderBySection(){
    Widget widget=Row(
      children: [
        TextButton(
            onPressed: () {
              sqLite.setOrderBy('editedTime DESC');
              init();
            },
            child: Text('최근 수정 순')),
        TextButton(
            onPressed: () {
              sqLite.setOrderBy('grade DESC');
              init();
            },
            child: Text('높은 학년 순')),
        TextButton(
            onPressed: () {
              sqLite.setOrderBy('createTime DESC');
              init();
            },
            child: Text('최근 생성 순')),
        TextButton(
            onPressed: () {
              sqLite.setOrderBy('viewTime DESC');
              init();
            },
            child: Text('최근 열람 순'))
      ],
    );
    return widget;
  }

  Widget listSection(BuildContext context) {
    final List<Widget> widgetList = [];

    list.forEach((element) {
      widgetList.add(unit(context, element));
    });

    return Column(
      children: widgetList,
    );
  }

  Widget unit(BuildContext context, userInfo box) {
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
                    "학년: " + box.grade,
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
                    '답:' + box.answerList().toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '수정 시간: ' + box.editedTime,
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '생성 시간: ' + box.createTime,
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '최근 본 시간: ' + box.viewTime,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                ],
              ),
            ],
          ),
          CupertinoButton(
              child: Text('이동하기'),
              onPressed: () {
                userInfo user = box;
                user.viewTime = DateTime.now().toString();
                sqLite.insertTime(user);
                _navigateHomePage(context, box);
              }),
          CupertinoButton(
              child: Text('수정하기'),
              onPressed: () {
                _navigateEditPage(context, box);
              }),
          CupertinoButton(
              child: Text('삭제하기'),
              onPressed: () {
                delete(box.id);
                init();
              })
        ],
      ),
    );

    return wi;
  }
}
