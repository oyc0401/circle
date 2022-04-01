
import 'package:circle/page/home.dart';
import 'package:circle/playground.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'page/setting.dart';
import 'page/view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          child: child!,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      //home: const MyHomePage(title: 'circle'),
      //home: const EditPage(id: 'id',),
      home: const ViewPage(title: 'circle'),
      //home: const playground(title: '놀이터'),

      // const MyHomePage(title: 'circle'),
      // const playground(title: '놀이터'),
    );
  }
}
