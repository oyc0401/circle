class KoreanNumber{

  KoreanNumber(int number){
    this.number=number;
  }

  int number=1;

  String getnumber(){
    String text='';

    if(number<100){
      text=_changetwice(number);
    }else if(100<=number&&number<200){
      int twice=number-100;
      text='백'+_changetwice(twice);
    }else if(200<=number&&number<1000){
      int firstnum=number~/100;
      int twice=number-(100*firstnum);
      text=_list[firstnum]+'백'+_changetwice(twice);
    }

    return text;
  }

   _changetwice(int number){
    String text='';

    if(number<10){
      text=_list[number];
    } else if(10<=number && number<20){
      int secondnm=number%10;
      text='십'+_list[secondnm];
    }else if(20<=number && number<100){
      int firstnum=number~/10;
      int secondnm=number%10;
      text=_list[firstnum]+'십'+_list[secondnm];
    }

    return text;
  }


  _check(){
    for(int i=0;i<=999;i++){
      print(KoreanNumber(i).getnumber());
    }
  }



List _list=['','일','이','삼','사','오','육','칠','팔','구'];
}