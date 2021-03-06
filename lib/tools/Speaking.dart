import 'package:flutter_tts/flutter_tts.dart';

import '../DB/HardText.dart';
import 'KoreanNumber.dart';

class Speaking {
  Speaking() {
    _flutterTts.setSpeechRate(HardText.speechRate);
    _flutterTts.setVolume(HardText.volume);
    _flutterTts.setPitch(HardText.pitch);
    //_flutterTts.setVoice({'name': 'ko-kr-x-kod-network', 'locale': 'ko-KR'});
    _flutterTts.setVoice(HardText.voice);
  }

  final FlutterTts _flutterTts = FlutterTts();
  List _answers = [];
  int _position = 0;
  bool _isSpeak = false;
  int numberDuration = HardText.numberDuration;
  int answerDuration = HardText.answerDuration;

  getAnswers() => _answers;

  getPosition() => _position;

  setAnswers(List list) => _answers = list;

  setSpeechRate(double rate) => _flutterTts.setSpeechRate(rate);

  setVolume(double volume) => _flutterTts.setVolume(volume);

  setPitch(double pitch) => _flutterTts.setPitch(pitch);

  setVoice(Map<String, String> voice) => _flutterTts.setVoice(voice);

  setAnswerDuration(int dur) => answerDuration = dur;

  setNumberDuration(int du) => numberDuration = du;

  void practiceStart()async{
    //await _flutterTts.speak("안녕하세요, 1번, 2번, 3번, 4번, 5번, 북치기박치기북치기박치기");
    await _flutterTts.speak("4");


  }

  void speak(int number, Function fun) {
    print('$number번 부터 말하기');

    if (_isSpeak == true) {
      stop();
    }

    _isSpeak = true;
    _talkNum(number, fun);
  }

  void stop() {
    _flutterTts.stop();
    _isSpeak = false;
  }

  Future _talkNum(int number, Function setstate) async {
    _position = number;
    setstate();
    if (_answers.length < number) {
      return 0;
    }

    String koreanNum = KoreanNumber(number).getnumber();
    await Future.delayed(Duration(milliseconds: answerDuration));
    if (_isSpeak == true && _position == number)
      await _flutterTts.speak("$koreanNum번");
    _flutterTts.setCompletionHandler(() async {
      print('number Complete');

      if (_isSpeak == true && _position == number)
        _talkAnswer(number, setstate);
    });
  }

  Future _talkAnswer(int number, Function fun) async {
    int whereArray = number - 1;
    String answer = _answers[whereArray].toString();
    await Future.delayed(Duration(milliseconds: numberDuration));
    if (_isSpeak == true && _position == number)
      await _flutterTts.speak(answer);

    _flutterTts.setCompletionHandler(() async {
      print('answer Complete');
      if (_isSpeak == true && _position == number) _talkNum(number + 1, fun);
    });
  }
}
