import 'package:circle/DB/shared.dart';
import 'package:circle/DB/sqlLite.dart';
import 'package:circle/tools/Speaking.dart';
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
  final String Title = '3학년 listning';
  Speaking speaking = Speaking();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {

    // keyValue.setVolume(1);
    // keyValue.setPitch(0.9);
    // keyValue.setSpeechRate(0.5);
    // keyValue.setVoice({'name': 'ko-kr-x-kod-network', 'locale': 'ko-KR'});


      speaking.setAnswers(widget.userinfo.answerList());
      setState(() {});

   await getDATA();

  }
  getDATA()async{
    KeyValue keyValue = await KeyValue.Instance();
    speaking.setVolume(keyValue.getVolume());
    speaking.setPitch(keyValue.getPitch());
    speaking.setSpeechRate(keyValue.getSpeechRate());
    //speaking.setVoice(keyValue.getVoice());
  }

  @override
  Widget build(BuildContext context) {
    print('뷰');
    return Scaffold(
      appBar: AppBar(
        title: Text('circle'),
        actions: [
          IconButton(
            onPressed: () {
              speaking.stop();
              Navigator.push(
                  context, CupertinoPageRoute(builder: (context) =>  SettingPage()));
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),

      bottomNavigationBar: BottomAppBar(child: navigationRow()),
      body: Column(
        children: [
          Expanded(
              child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
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

    List<Widget> singleWidgets(List Answers) {
      List<Widget> widgets = [];

      for (int i = 0; i < Answers.length; i++) {
        String text = answers[i].toString();
        if (text.length > 1) {
          text = '서';
        }
        int number = i + 1;

        Color thiscolor = Colors.white;
        if (speaking.getPosition() == number) {
          thiscolor = Colors.redAccent;
        }

        Widget circle = Container(
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
                  print(answers[i].toString());
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

        widgets.add(circle);
      }

      return widgets;
    }

    List<Widget> rows(List<Widget> values) {
      List<Widget> list = [];

      while (values.length % 5 != 0) {
        values.add(Container(
          height: 80,
          width: 65,
          // color: Colors.black,
        ));
      }

      int rowNum = values.length ~/ 5;
      for (int i = 0; i < rowNum; i++) {
        Widget column = Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // 같은 간격만큼 공간을 둠
                children: values.sublist(0, 5)),
            Container(
              height: 0.5,
              color: Colors.black,
            )
          ],
        );

        list.add(column);
        values.removeRange(0, 5);
      }

      return list;
    }

    Widget context = Container(
        //color: Colors.green,
        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
        child: Column(children: rows(singleWidgets(answers))));

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
    await Future.delayed(Duration(milliseconds: 50));
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
