import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'home.dart';
import 'view.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key, required this.ID}) : super(key: key);
  final int ID;

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  int day = 0;
  int hour = 0;
  int minute = 0;
  String title = '제목 없음';
  String where = 'day';

  Color colday = Colors.red;
  Color colhour = Colors.deepPurpleAccent;
  Color colminute = Colors.deepPurpleAccent;

  final keys = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['00', '0', Icon(Icons.keyboard_backspace)],
  ];
  final List names=['자원지', '연구', '건설 1', '건설 2', '병사','제목없음','제목없음','제목없음','제목없음','제목없음','제목없음','제목없음','제목없음','제목없음',];

  late final Future<Database> database;

  Future joinDatabase() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'circle_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE times(id TEXT PRIMARY KEY, title TEXT, answers TEXT, grade TEXT, createTime TEXT, editedTime TEXT)",
        );
      },
      version: 1,
    );
  }

  Future insertTime() async {
    print('추가됌');

    Future<void> insertTime(userInfo time) async {
      final Database db = await database;
      await db.insert(
        'times',
        time.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    DateTime now = DateTime.now();
    DateTime thatTime =
    now.add(Duration(days: day, hours: hour, minutes: minute));
    print(thatTime);
    String thatString = DateFormat('yyyy-MM-dd hh:mm:ss').format(thatTime);

    final newtime = userInfo(
      id: 'id',
      title: 'title',
      answers: 'dsa',
      grade: 'rrr',
      createTime: 'rreww',
      editedTime: '3sad',
    );
    await insertTime(newtime);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    joinDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('추가하기'),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CupertinoButton(
                child: Text('$day 일'),
                onPressed: () {
                  where = 'day';
                  print('switched by day');
                  changeStyle();
                },
                padding: EdgeInsets.fromLTRB(40, 14, 40, 14),
                color: colday,
              ),
              CupertinoButton(
                child: Text('$hour 시간'),
                onPressed: () {
                  where = 'hour';
                  print('switched by hour');
                  changeStyle();
                },
                padding: EdgeInsets.fromLTRB(40, 14, 40, 14),
                color: colhour,
              ),
              CupertinoButton(
                child: Text('$minute 분'),
                onPressed: () {
                  where = 'minute';
                  print('switched by minute');
                  changeStyle();
                },
                padding: EdgeInsets.fromLTRB(40, 14, 40, 14),
                color: colminute,
              )
            ],
          ),

          SizedBox(
            height: 20,
          ),
          CupertinoButton(
            child: Text('추가'),
            onPressed: () {
              insertTime();
              Navigator.pop(context);
            },
            color: Colors.deepPurpleAccent,
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: keys
                .map(
                  (x) => Row(
                children: x.map((y) {
                  return Expanded(
                    child: KeyboardKey(
                      label: y,
                      onTap: y is Widget ? onBackspacePress : onNumberPress,
                      value: y,
                    ),
                  );
                }).toList(),
              ),
            )
                .toList(),
          )
          // CustomKeyboardScreen()
        ],
      ),
    );
  }

  onBackspacePress(val) {
    print('지우기 where: $where');
    if (where == 'day') {
      String string = day.toString();

      // 한자리 수 일때
      if (string.length != 1) {
        day = int.parse(string.substring(0, string.length - 1));
      } else {
        day = 0;
      }
      print('$where: $day');
    } else if (where == 'hour') {
      String string = hour.toString();

      // 한자리 수 일때
      if (string.length != 1) {
        hour = int.parse(string.substring(0, string.length - 1));
      } else {
        hour = 0;
      }
      print('$where: $hour');
    } else {
      String string = minute.toString();

      // 한자리 수 일때
      if (string.length != 1) {
        minute = int.parse(string.substring(0, string.length - 1));
      } else {
        minute = 0;
      }
      print('$where: $minute');
    }

    setState(() {});
  }

  onNumberPress(val) {
    print('click: $val, where: $where');

    if (where == 'day') {
      String num;
      if (day == 0) {
        num = val.toString();
      } else {
        num = day.toString() + val.toString();
      }
      day = int.parse(num);

      if(day>999){
        day=0;
      }
    } else if (where == 'hour') {
      String num;
      if (hour == 0) {
        num = val.toString();
      } else {
        num = hour.toString() + val.toString();
      }
      hour = int.parse(num);

      if(hour>24){
        hour=0;
      }

    } else {
      String num;
      if (minute == 0) {
        num = val.toString();
      } else {
        num = minute.toString() + val.toString();
      }
      minute = int.parse(num);

      if(minute>60){
        minute=0;
      }
    }

    setState(() {});
  }

  changeStyle(){
    print('머징$where');
    if (where == 'day') {
      colday = Colors.red;
      colhour = Colors.deepPurpleAccent;
      colminute = Colors.deepPurpleAccent;
    } else if (where == 'hour') {
      colday = Colors.deepPurpleAccent;
      colhour = Colors.red;
      colminute = Colors.deepPurpleAccent;
    } else {
      colday = Colors.deepPurpleAccent;
      colhour = Colors.deepPurpleAccent;
      colminute = Colors.red;
    }
    setState(() {

    });
  }
}

class KeyboardKey extends StatefulWidget {
  final dynamic label; // 이거 dynamic 으로 변경
  final dynamic value;
  final ValueSetter<dynamic> onTap;

  KeyboardKey({
    required this.label,
    required this.onTap,
    required this.value,
  })  : assert(label != null),
        assert(onTap != null),
        assert(value != null);

  @override
  _KeyboardKeyState createState() => _KeyboardKeyState();
}

class _KeyboardKeyState extends State<KeyboardKey> {
  // 조건부 렌더링!
  renderLabel() {
    if (widget.label is String) {
      return Text(
        widget.label,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      return widget.label;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap(widget.value);
      },
      child: AspectRatio(
        aspectRatio: 2,
        child: Container(
          child: Center(
            child: renderLabel(),
          ),
        ),
      ),
    );
  }
}
