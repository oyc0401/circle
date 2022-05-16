import 'package:circle/tools/SrtingHandle.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../DB/sqlLite.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key, required this.title, required this.userinfo})
      : super(key: key);
  final String title;
  final userInfo userinfo;

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late userInfo userinfo = widget.userinfo;
  List answers = ['', '', '', '', '', '', ''];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() {
    answers = userinfo.answerList();
    addLine();
    addLine();
  }

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

    user.editedTime = DateTime.now().toString();
    print(answers);
    List list = lastRemove(answers);
    userinfo.answers = StringHandle.ListToString(list);
    print(StringHandle.ListToString(list));

    SQLite sqLite = SQLite();
    await sqLite.insertTime(user);

    Navigator.of(context).pop(true);
  }

  addLine() {
    answers.add('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        actions: [
          TextButton(
              onPressed: () {
                save(userinfo, context);
              },
              child: Text(
                '저장',
                style: TextStyle(fontSize: 18, color: Colors.black),
              )),
        ],
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                titleSection(),
                gradeSection(),
                inputSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  titleSection() {
    return TextFormField(
      initialValue: userinfo.title,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        hintText: '제목',
      ),
      onChanged: (value) {
        userinfo.title = value;
      },
    );
  }

  gradeSection() {
    return TextFormField(
      initialValue: userinfo.grade,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        hintText: '학년',
      ),
      onChanged: (value) {
        userinfo.grade = value;
      },
    );
  }

  Widget inputSection() {
    List<Widget> list = [];
    //print("인풋: $numline, "+answers.length.toString());

    for (int i = 1; i <= answers.length; i++) {
      list.add(inputWidget(i));
    }

    return Column(
      children: [
        SizedBox(
          height: 12,
        ),
        ...list
      ],
    );
  }

  Widget inputWidget(int num) {
    Color color = Colors.white;
    if (num % 10 > 5) {
      color = Colors.black12;
    } else if (num % 10 == 0) {
      color = Colors.black12;
    }

    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
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
              initialValue: answers[num - 1],
              style: TextStyle(fontSize: 16),
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              onChanged: (value) {
                answers[num - 1] = value;
                print(answers);
                print(answers.length.toString() + ", $num");
                if (answers.length <= num + 1) {
                  print('줄 추가!');
                  addLine();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
