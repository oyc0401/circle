import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class KeyValue {
  // set 하는것은 Instance가 필요 없지만
  // get 은 퓨처값을 주지 말아야 하기 때문에 Instance가 필요하다.
  late SharedPreferences prefs;


  static Instance() async {
    KeyValue key = KeyValue();
    key.prefs = await SharedPreferences.getInstance();
    return key;
  }

  setPitch(double pitch) {
    prefs.setDouble('pitch', pitch);
  }

  setVolume(double volume) {
    prefs.setDouble('volume', volume);
  }

  setSpeechRate(double speechRate) {
    prefs.setDouble('speechRate', speechRate);
  }

  setVoice(Map voice) {
    String name = voice['name'];
    String locale = voice['locale'];
    prefs.setString('voice_name', name);
    prefs.setString('voice_locale', locale);
  }

  //

  double getPitch() {
    double pitch = prefs.getDouble('pitch') ?? 1;
    return pitch;
  }

  double getVolume() {
    double volume = prefs.getDouble('volume') ?? 1;
    return volume;
  }

  double getSpeechRate() {
    double speechRate = prefs.getDouble('speechRate') ?? 1;
    return speechRate;
  }

  Map<String, String> getVoice() {
    String name = prefs.getString('voice_name') ?? "";
    String locale = prefs.getString('voice_locale') ?? "";
    Map<String, String> voice = {'name': name, 'locale': locale};
    return voice;
  }
}
