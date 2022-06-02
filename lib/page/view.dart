import 'dart:math';

import 'package:circle/DB/sqlLite.dart';
import 'package:circle/page/home.dart';
import 'package:circle/tools/Time.dart';
import 'package:circle/tools/Tools.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../tools/SrtingHandle.dart';
import 'edit.dart';
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
  String? selectedSort;

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
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,

      ),
      body: ListView(
        children: [orderBySection(context),


          listSection(context)],
      ),
      floatingActionButton: FloatingAddButton(context),
    );
  }

  FloatingActionButton FloatingAddButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        userInfo us = userInfo(
            id: StringHandle.String2Sha256(DateTime.now().toString()),
            title: '',
            answers: StringHandle.ListToString(['', '', '']),
            grade: '',
            editedTime: DateTime.now().toString(),
            createTime: DateTime.now().toString(),
            viewTime: DateTime.now().toString());
        //_navigateWritePage(context);
        _navigateEditPage(context, us, '추가하기');
      },
      tooltip: '추가하기',
      child: const Icon(Icons.add),
      backgroundColor: Colors.redAccent,
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
          value: selectedSort,
          onChanged: (value) {
            setState(() {
              selectedSort = value.toString();

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
    if (user_infomations.length != 0) {
      user_infomations.forEach((element) {
        widgetList.add(unit(context, element));
      });
    } else {
      print('dsdadsadadda' + user_infomations.length.toString());
      widgetList.add(Container());
    }

    return Column(
      children: widgetList,
    );
  }

  Widget unit(BuildContext context, userInfo box) {
    print(box.toMap());

    Widget titleRow(BuildContext context) {
      return Row(
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
                  _onTapDeleteButton(box, context);
                }
              }),
        ],
      );
    }

    Widget circleRow() {
      List answers = box.answerList();
      List<Widget> circles = [];
      for (int i = 0; i < answers.length; i++) {
        String answer = Tools.seosul(answers[i]);
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
            child: Text(answer,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w500)),
          ),
        );

        circles.add(circle);
      }
      return Container(
          height: 40,
          child: ListView(scrollDirection: Axis.horizontal, children: circles));
    }

    Widget bottom() {
      String timetext = box.editedTime;
      String diff = Time.timeDifferent(timetext);

      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 20, 0),
        child: Row(
          children: [
            Spacer(),
            Text(
              '최종 수정일: $diff',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
      child: InkWell(
        onTap: () {
          _onTapBox(box, context);
        },
        child: Card(
          shape: RoundedRectangleBorder(
            //side: BorderSide(width: 0),
            //모서리를 둥글게 하기 위해 사용
            borderRadius: BorderRadius.circular(16.0),
          ),

          color: Color(0xffffe4e1),
          child: Container(
            padding: const EdgeInsets.fromLTRB(18, 8, 8, 8),
            child: Column(
              children: [
                titleRow(context),
                circleRow(),
                bottom(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateEditPage(
      BuildContext context, userInfo user, String title) async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => EditPage(title: title, userinfo: user)),
    );
    print('back');
    init();
  }

  void _navigateHomePage(BuildContext context, userInfo user) async {
    await Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => MyHomePage(userinfo: user)),
    );
    print('back');
    init();
  }

  void _onTapDeleteButton(userInfo box, BuildContext context) {
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
                child: Text("네"),
                onPressed: () {
                  Navigator.pop(context);
                  print("삭제하기");
                  sqLite.deleteInfo(box.id);
                  init();
                },
              ),
              TextButton(
                child: Text("아니요"),
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
    _navigateEditPage(context, box, '수정하기');
  }

  void _onTapBox(userInfo box, BuildContext context) {
    print('이동하기');
    userInfo user = box;
    user.viewTime = DateTime.now().toString();
    sqLite.insertTime(user);
    _navigateHomePage(context, box);
  }
}
