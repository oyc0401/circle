main(){
  List a = ['a', 'b', 'c', 'd', 'e'];
  List b = a;

  b.removeLast();

  print(a);
  print(b);
}