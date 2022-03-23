class Speaking{

  // Speaking(){
  //
  // }
  int position;
  int initialStart;
  bool isSpeak = false;
  FlutterTts flutterTts = FlutterTts();
  final double speechRate = 0.5;
  final double volume = 1;
  final double pitch = 0.9;
  final Map<String, String> voice = {
    'name': 'ko-kr-x-kod-network',
    'locale': 'ko-KR'
  };


  speak(){}
  stop(){}

}