import 'dart:math';

import 'package:circle/tools/KoreanNumber.dart';
import 'package:circle/tools/Speaking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'home.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String Title = '3학년 listning';
  Speaking speaking = Speaking();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    getList().then((answers) {
      return speaking.setAnswers(answers);
    });
    speaking.setPitch(0.9);
    speaking.setVolume(1);
    speaking.setSpeechRate(0.5);
    speaking.setVoice({'name': 'ko-kr-x-kod-network', 'locale': 'ko-KR'});
  }

  @override
  Widget build(BuildContext context) {
    print('뷰');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      bottomNavigationBar: BottomAppBar(child: navigationRow()),
      body: Column(
        children: [
          Expanded(
              child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  Title,
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
    Widget context = Container();

    List<Widget> answerwidgets(List answersList) {
      List<Widget> list = [];

      for (int i = 0; i < answersList.length; i++) {
        String text = answers[i].toString();
        if (text.length > 1) {
          //text = '서';
        }
        int number = i + 1;

        Color thiscolor = Colors.deepPurpleAccent;
        if (speaking.getPosition() == number) {
          thiscolor = Colors.redAccent;
        }

        Widget circle = Column(
          children: [
            InkWell(
              onTap: () {
                speaking.speak(number, setstate);
              },
              onLongPress: () {
                print(answers[i].toString());
              },
              child: Container(
                width: 65,
                height: 65,
                margin: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: thiscolor,
                ),
                child: Center(
                  child: Text(text,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 25.0)),
                ),
              ),
            ),
            Text('$number번',
                style: const TextStyle(color: Colors.black, fontSize: 15.0)),
            SizedBox(
              height: 10,
            )
          ],
        );

        list.add(circle);
      }

      return list;
    }

    List<Widget> rows(List<Widget> values) {
      List<Widget> list = [];

      int ahrt = values.length ~/ 5;
      for (int i = 0; i < ahrt; i++) {
        list.add(Row(children: values.sublist(0, 5)));

        for (int k = 1; k <= 5; k++) {
          values.removeAt(0);
        }
      }
      //print((values.length));
      list.add(Row(children: values.sublist(0, values.length)));

      return list;
    }

    context = Column(children: rows(answerwidgets(answers)));

    return context;
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

  Future<List> getList() async {
    List list = _answers;
    return list;
  }

  final List _answers = [
    1,
    2,
    3,
    4,
    5,
    'snow',
    2,
    3,
    4,
    5,
    1,
    2,
    3,
    4,
    5,
    1,
    2,
    3,
    4,
    5,
    1,
    2,
    3,
    4,
    5,
    1,
    2,
    3,
  ];
}
