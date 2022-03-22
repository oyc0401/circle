import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'home.dart';

class MyHomePage2 extends StatefulWidget {
  const MyHomePage2({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage2> createState() => _MyHomePage2State();
}

class _MyHomePage2State extends State<MyHomePage2> {
  FlutterTts flutterTts = FlutterTts();

  //List answers = [4, 3, 6, 2, 5, 'snow', 3, 2, 6];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future _speak() async {
    flutterTts.speak("Hello,. World,     안,녕");
  }

  Future _stop() async {
    flutterTts.stop();
  }

  void init() {
    flutterTts.setSpeechRate(0.4);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    _speak();
                  },
                  child: Text('Speak')),
              ElevatedButton(
                  onPressed: () {
                    _stop();
                  },
                  child: Text('stop')),

            ],
          ),
        ));
  }
}
