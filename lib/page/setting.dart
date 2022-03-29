import 'dart:math';

import 'package:circle/tools/Speaking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../DB/shared.dart';

class SettingPage extends StatefulWidget {
  SettingPage({
    Key? key,
  }) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  double volume = 1;
  double pitch = 0.9;
  double rate = 0.5;
  int answerDuration=500;
  int numDuration=300;

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
    numDuration=keyValue.getNumberDuration();
    answerDuration=keyValue.getAnswerDuration();
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
          Text('setting'),
          editSection(),
          CupertinoButton(child: Text('저장'), onPressed: _save),
          CupertinoButton(
              child: Text('초기화'),
              onPressed: () {
                volume = 1;
                pitch = 0.9;
                rate = 0.5;
                numDuration=300;
                answerDuration=500;

                setState(() {});
              })
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
      children: [_volume(), _pitch(), _rate(),_numDuration(),_ansDuration()],
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
