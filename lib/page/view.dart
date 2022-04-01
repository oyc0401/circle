import 'dart:math';

import 'package:circle/DB/sqlLite.dart';
import 'package:circle/page/home.dart';
import 'package:circle/page/write.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
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
  List<userInfo> user_infomations = [];
  SQLite sqLite = SQLite();
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    init();
  }

  void setorderby(String value) {
    switch (value) {
      case '최근 열람 순':
        print(value);
        sqLite.setOrderBy('viewTime DESC');
        break;
      case '최근 수정 순':
        print(value);
        sqLite.setOrderBy('editedTime DESC');
        break;
      case '높은 학년 순':
        print(value);
        sqLite.setOrderBy('grade DESC');
        break;
      case '최근 생성 순':
        print(value);
        sqLite.setOrderBy('createTime DESC');
        break;
    }
    init();
  }

  init() async {
    print('init');
    user_infomations = await sqLite.getInfo();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: [orderBySection(context), listSection(context)],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateWritePage(context);
        },
        tooltip: '추가하기',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget orderBySection(BuildContext context) {
    final List<String> items = [
      '최근 열람 순',
      '최근 수정 순',
      '높은 학년 순',
      '최근 생성 순',
    ];
    return Center(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          hint: const Text(
            '최근 열람 순',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ))
              .toList(),
          value: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value.toString();

              setorderby(value.toString());
            });
          },
          buttonHeight: 40,
          buttonWidth: 140,
          itemHeight: 40,
        ),
      ),
    );
  }

  Widget listSection(BuildContext context) {
    final List<Widget> widgetList = [];

    user_infomations.forEach((element) {
      widgetList.add(unit(context, element));
    });

    return Column(
      children: widgetList,
    );
  }

  Widget unit(BuildContext context, userInfo box) {
    print(box.toMap());

    Widget circleRow() {
      List answers = box.answerList();
      List<Widget> circles = [];
      for (int i = 0; i < answers.length && i < 5; i++) {
        Widget circle = Container(
          width: 40,
          height: 40,
          margin: EdgeInsets.fromLTRB(0, 0, 6, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(),
          ),
          child: Center(
            child: Text(answers[i],
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w500)),
          ),
        );

        circles.add(circle);
      }
      return Row(children: circles);
    }

    return InkWell(
      onTap: () {
        _onTapBox(box, context);
      },
      child: Container(
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
                const SizedBox(
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
                Spacer(),
                PopupMenuButton(
                    icon: Icon(Icons.more_vert),
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem<int>(
                          value: 0,
                          child: Text("수정"),
                        ),
                        const PopupMenuItem<int>(
                          value: 1,
                          child: Text("삭제"),
                        ),
                      ];
                    },
                    onSelected: (value) {
                      if (value == 0) {
                        _onTapEditButton(context, box);
                      } else if (value == 1) {
                        _onTapDeleteButton(box,context);
                      }
                    }),
              ],
            ),
            circleRow(),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
          ],
        ),
      ),
    );
  }

  void _navigateEditPage(BuildContext context, userInfo user) async {
    await Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => EditPage(userinfo: user)),
    );
    print('back');
    init();
  }

  void _navigateWritePage(BuildContext context) async {
    await Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => WritePage()),
    );
    print('back');
    init();
  }

  void _navigateHomePage(BuildContext context, userInfo user) async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => MyHomePage(userinfo: user)),
    );
    print('back');
    init();
  }

  void _onTapDeleteButton(userInfo box ,BuildContext context) {

    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Text("삭제"),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "삭제 하시겠습니까?",
                ),
              ],
            ),
            actions: <Widget>[
               TextButton(
                child:  Text("네"),
                onPressed: () {
                  Navigator.pop(context);
                  print("삭제하기");
                  sqLite.deleteInfo(box.id);
                  init();
                },
              ),
              TextButton(
                child:  Text("아니요"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void _onTapEditButton(BuildContext context, userInfo box) {
    print("수정하기");
    _navigateEditPage(context, box);
  }

  void _onTapBox(userInfo box, BuildContext context) {
    print('이동하기');
    userInfo user = box;
    user.viewTime = DateTime.now().toString();
    sqLite.insertTime(user);
    _navigateHomePage(context, box);
  }
}
