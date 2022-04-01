import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';

import '../DB/sqlLite.dart';

class StringHandle{

  static String String2Sha256(String text) {
    var bytes = utf8.encode(text); // data being hashed
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  static ListToString(List list) {
    String string = '';
    list.forEach((element) {
      string = '$string,$element';
    });
    print(string);
    return string;
  }

  static StringToList(String string) {
    List list = string.split(',');
    list.removeAt(0);
    return list;
  }

}