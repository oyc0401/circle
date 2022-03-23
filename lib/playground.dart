import 'dart:math';

import 'package:circle/tools/KoreanNumber.dart';
import 'package:circle/tools/Speaking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class playground extends StatefulWidget {
  const playground({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _playgroundState createState() => _playgroundState();
}

class _playgroundState extends State<playground> {
  @override
  Widget build(BuildContext context) {
    print('뷰');
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            Text('텍스트 '),
            Container(),
            Container(
              height: 100.0,
              width: 100.0,
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
                border: Border.all(),
              ),
            ),
            Center(
              child: Container(
                height: 100.0,
                width: 100.0,
                child: Center(child: Text('dd')),
                decoration: BoxDecoration(
                    color: Colors.amberAccent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                        spreadRadius: 2.0,
                      ),
                    ]),
              ),
            ),
            ButtonTheme(
              minWidth: 30,
              height: 30,
              shape: RoundedRectangleBorder(
                  //버튼을 둥글게 처리
                  borderRadius: BorderRadius.circular(10)),
              child: RaisedButton(
                //ButtonTheme의 child로 버튼 위젯 삽입
                onPressed: () {},
                child: Text(
                  '예시 버튼 텍스트',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                color: Colors.deepPurple,
              ),
            )
          ],
        ));
  }
}
