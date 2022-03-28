import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../DB/sqlLite.dart';
import 'home.dart';
import 'view.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key, required this.userinfo}) : super(key: key);
  final userInfo userinfo;

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {

  late userInfo userinfo = widget.userinfo;

  List<userInfo> list=[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async{
    SQLite sqLite=await SQLite.Instance();
    list= await sqLite.getInfo();
  }

  save(userInfo user) async{
    SQLite sqLite=await SQLite.Instance();
    await sqLite.insertTime(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('추가하기'),
      ),
      body: ListView(
        children: [
          TextFormField(
            initialValue: widget.userinfo.title,
            decoration: const InputDecoration(
              labelText: 'title',
            ),
            onChanged: (value) {
              userinfo.title=value;
            },
          ),
          TextFormField(
            initialValue: widget.userinfo.grade,
            decoration: const InputDecoration(
              labelText: 'grade',
            ),
            onChanged: (value) {
              userinfo.grade=value;
            },
          ),
          
          CupertinoButton(
              child: Text('저장하기'),
              onPressed: () {
                save(userinfo);
              })
        ],
      ),
    );
  }
}
