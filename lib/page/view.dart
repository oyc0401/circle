import 'dart:math';

import 'package:circle/DB/sqlLite.dart';
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

  @override
  void initState() {
    super.initState();
    init();
  }

  delete(String id) async {
    SQLite sqLite = await SQLite.Instance();
    sqLite.deleteInfo(id);
  }

  init() async {
    print('init');
    SQLite sqLite = await SQLite.Instance();
    list = await sqLite.getInfo();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => WritePage()));
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: ListView(
        children: [
          CupertinoButton(
              child: Text('새로고침'),
              onPressed: () {
                init();
              }),
          listSection(context)
        ],
      ),
    );
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
                    box.createTime,
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
          CupertinoButton(
              child: Text('수정하기'),
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => EditPage(
                              userinfo: box,
                            )));
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
