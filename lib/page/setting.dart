import 'dart:math';

import 'package:circle/tools/Speaking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../DB/HardText.dart';
import '../DB/shared.dart';

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class SettingPage extends StatefulWidget {
  SettingPage({
    Key? key,
  }) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  double volume = 1;
  double pitch = 1;
  double rate = 0.5;
  int answerDuration = 500;
  int numDuration = 300;

  _save() async {
    KeyValue keyValue = await KeyValue.Instance();
    keyValue.setVolume(volume);
    keyValue.setPitch(pitch);
    keyValue.setSpeechRate(rate);
    keyValue.setNumberDuration(numDuration);
    keyValue.setAnswerDuration(answerDuration);
    Navigator.of(context).pop(true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    KeyValue keyValue = await KeyValue.Instance();
    volume = keyValue.getVolume();
    pitch = keyValue.getPitch();
    rate = keyValue.getSpeechRate();
    numDuration = keyValue.getNumberDuration();
    answerDuration = keyValue.getAnswerDuration();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('setting'),
      ),
      body: Column(
        children: [
          editSection(),
          CupertinoButton(
              child: Text('초기화'),
              onPressed: () {
                volume = HardText.volume;
                pitch = HardText.pitch;
                rate = HardText.speechRate;
                numDuration = HardText.numberDuration;
                answerDuration = HardText.answerDuration;

                setState(() {});
              }),
          CupertinoButton(child: Text('저장'), onPressed: _save),
        ],
      ),
    );
  }

  Widget editSection() {
    Widget widget = _buildSliders();
    return widget;
  }

  Widget _buildSliders() {
    return Column(
      children: [
        SizedBox(
          height: 18,
        ),
        Text(
          '볼륨',
          style: TextStyle(fontSize: 15),
        ),
        _volume(),
        Text('높낮이', style: TextStyle(fontSize: 15)),
        _pitch(),
        Text('속도', style: TextStyle(fontSize: 15)),
        _rate(),
        Text('숫자 간격', style: TextStyle(fontSize: 15)),
        _numDuration(),
        Text('정답 간격', style: TextStyle(fontSize: 15)),
        _ansDuration()
      ],
    );
  }

  Widget _volume() {
    return Slider(
        value: volume,
        onChanged: (newVolume) {
          setState(() => volume = newVolume);
        },
        min: 0.0,
        max: 2.0,
        divisions: 20,
        label: "Volume: $volume");
  }

  Widget _pitch() {
    return Slider(
      value: pitch,
      onChanged: (newPitch) {
        setState(() => pitch = newPitch);
      },
      min: 0.0,
      max: 2.0,
      divisions: 20,
      label: "Pitch: $pitch",
      activeColor: Colors.red,
    );
  }

  Widget _rate() {
    return Slider(
      value: rate,
      onChanged: (newRate) {
        setState(() => rate = newRate);
      },
      min: 0.0,
      max: 1.0,
      divisions: 10,
      label: "Rate: $rate",
      activeColor: Colors.green,
    );
  }

  Widget _numDuration() {
    return Slider(
      value: numDuration.toDouble(),
      onChanged: (newDuration) {
        setState(() => numDuration = newDuration.toInt());
      },
      min: 0,
      max: 1000,
      divisions: 10,
      label: "numDuration: $numDuration",
      activeColor: Colors.yellow,
    );
  }

  Widget _ansDuration() {
    return Slider(
      value: answerDuration.toDouble(),
      onChanged: (newDuration) {
        setState(() => answerDuration = newDuration.toInt());
      },
      min: 0,
      max: 1000,
      divisions: 10,
      label: "answerDuration: $answerDuration",
      activeColor: Colors.purple,
    );
  }
}
