import 'dart:math';

import 'package:circle/KoreanNumber.dart';
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
  FlutterTts flutterTts = FlutterTts();
  bool isSpeak = false;
  int position = 0;
  double speechRate = 0.5;
  double volume = 1;
  double pitch = 0.9;
  Map<String, String> voice = {
    'name': 'ko-kr-x-kod-network',
    'locale': 'ko-KR'
  };
  String text='3학년 listning';

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    flutterTts.setSpeechRate(speechRate);
    flutterTts.setVolume(volume);
    flutterTts.setPitch(pitch);
    flutterTts.setVoice(voice);

    // {name: ko-kr-x-ism-local, locale: ko-KR} 이상한 섞인 목소리
    // {'name': 'ko-kr-x-ism-network', 'locale': 'ko-KR'} 피치 약간 높힌 여자 목소리     여자 목소리 채택
    // {name: ko-kr-x-kob-network, locale: ko-KR} 느린 여자 목소리
    // {'name': 'ko-kr-x-koc-network', 'locale': 'ko-KR'} 약간 낮은 남자 목소리
    // {'name': 'ko-kr-x-kod-network', 'locale': 'ko-KR'} 좀 빠른 남자 목소리      현재 목소리
    // {name: ko-KR-language, locale: ko-KR} 이상한 섞인 목소리
    // {'name': 'ko-kr-x-kob-local', 'locale': 'ko-KR'} 피치 낮춘 여자목소리
    // {'name': 'ko-kr-x-kod-local', 'locale': 'ko-KR'} 피치 더낮춘 여자 목소리
    // {'name': 'ko-kr-x-koc-local', 'locale': 'ko-KR'} 낮은 남자 목소리
    flutterTts.getVoices.then((value) {
      //print(value);
      List list = value;
      list.forEach((element) {
        print(element);
      });
      //flutterTts.setVoice({'locale': 'ko-KR', 'name': 'Yuna'});
    });
  }

  Future _speak(int where) async {
    print('$where번 부터 말하기');
    isSpeak = true;

    for (int i = where; i < _answers.length; i++) {
      print("i: $i");
      int number = i + 1;
      setState(() {
        position = number;
      });
      String koreanNum = KoreanNumber(number).getnumber();
      String answer = _answers[i].toString();
      await _talk("$koreanNum번", 300);
      await _talk(answer, 500);

      if (isSpeak == false) break;
    }
  }

  Future _talk(String text, int duration) async {
    print('speak: $text');
    await flutterTts.speak(text);
    await _wait(duration);
  }

  Future _wait(int duration) async {
    bool isSpeaking = true;
    flutterTts.setCompletionHandler(() {
      print('Complete');
      isSpeaking = false;
    });

    /// 과부하 위험지역
    while (isSpeaking == true) {
      await Future.delayed(Duration(milliseconds: 16));
      if (isSpeaking == false) break;
    }
    await Future.delayed(Duration(milliseconds: duration));
  }

  Future _stop() async {
    flutterTts.stop();
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
          Expanded(child: ListView(
            children: [


              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(text,style: TextStyle(fontSize: 24,),),
              ),


              touchSection(_answers),
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
        if (position == number) {
          thiscolor = Colors.redAccent;
        }

        Widget circle = Column(
          children: [
            InkWell(
              onTap: () {
                _speak(i);
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
      print('몫: $ahrt');
      for (int i = 0; i < ahrt; i++) {
        list.add(Row(children: values.sublist(0, 5)));

        for (int k = 1; k <= 5; k++) {
          values.removeAt(0);
        }
      }
      print((values.length));
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
                  _stop();
                  isSpeak = false;
                }),
            const Text('STOP',
                style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.red))
          ]),
    ]);
  }

  List _answers = [
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
