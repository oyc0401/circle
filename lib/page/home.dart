import 'package:circle/DB/shared.dart';
import 'package:circle/DB/sqlLite.dart';
import 'package:circle/tools/Speaking.dart';
import 'package:circle/tools/Tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'setting.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.userinfo}) : super(key: key);
  final userInfo userinfo;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Speaking speaking = Speaking();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    speaking.setAnswers(widget.userinfo.answerList());
    setState(() {});
    await getDATA();
  }

  getDATA() async {
    KeyValue keyValue = await KeyValue.Instance();
    speaking.setVolume(keyValue.getVolume());
    speaking.setPitch(keyValue.getPitch());
    speaking.setSpeechRate(keyValue.getSpeechRate());
    speaking.setAnswerDuration(keyValue.getAnswerDuration());
    speaking.setNumberDuration(keyValue.getNumberDuration());
    //speaking.setVoice(keyValue.getVoice());
  }

  @override
  Widget build(BuildContext context) {
    print('뷰');
    return Scaffold(
      appBar: AppBar(
        title: Text('circle'),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              speaking.stop();
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => SettingPage()));
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(child: navigationRow()),
      body: Column(
        children: [
          // CupertinoButton(child: Text('시험'), onPressed: (){speaking.practiceStart();}),
          Expanded(
              child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Text(
                  widget.userinfo.title,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              touchSection(speaking.getAnswers()),
            ],
          )),
        ],
      ),
    );
  }

  Widget touchSection(List answers) {
    print('touchSection');

    // 가로로 긴 위젯
    List<Widget> singleWidgets(List Answers) {
      List<Widget> widgets = [];

      for (int i = 0; i < Answers.length; i++) {
        int number = i + 1;
        String answer = answers[i];
        widgets.add(SingleCircle(number, answer));
      }
      return widgets;
    }

    // 가로로 긴거 모은 리스트
    List<Widget> rows(List<Widget> values) {
      List<Widget> list = [];

      //리스트 길이를 5의 배수로 맞추기
      while (values.length % 5 != 0) {
        values.add(const SizedBox(
          height: 80,
          width: 65,
        ));
      }

      final int rowNum = values.length ~/ 5;
      for (int i = 0; i < rowNum; i++) {
        list.add(MultiCircle(values.sublist(0, 5)));
        values.removeRange(0, 5);
      }

      return list;
    }

    return Container(
        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
        child: Column(children: rows(singleWidgets(answers))));
  }

  Widget MultiCircle(List<Widget> values) {
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // 같은 간격만큼 공간을 둠
            children: values),
        Container(
          height: 0.5,
          color: Colors.black,
        )
      ],
    );
  }

  Widget SingleCircle(int number, String answer) {
    String text = Tools.seosul(answer);

    Color thiscolor = Colors.white;
    if (speaking.getPosition() == number) {
      thiscolor = Colors.redAccent;
    }

    return Container(
      //color: Colors.black,
      padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              getDATA();
              speaking.speak(number, setstate);
            },
            onLongPress: () {
              _onLongTapButton(answer);
            },
            child: Container(
              width: 65,
              height: 65,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 6),
              decoration: BoxDecoration(
                color: thiscolor,
                shape: BoxShape.circle,
                border: Border.all(),
              ),
              child: Center(
                child: Text(text,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 25.0,
                        fontWeight: FontWeight.w500)),
              ),
            ),
          ),
          Text('$number번',
              style: const TextStyle(color: Colors.black, fontSize: 15.0)),
        ],
      ),
    );
  }

  void _onLongTapButton(String text) {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Text(
              text,
            ),
            actions: <Widget>[
              TextButton(
                child: Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Row navigationRow() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                icon: Icon(Icons.stop),
                color: Colors.red,
                splashColor: Colors.redAccent,
                onPressed: () {
                  speaking.stop();
                }),
            const Text('STOP',
                style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.red))
          ]),
    ]);
  }

  setstate() {
    setState(() {});
  }
}
