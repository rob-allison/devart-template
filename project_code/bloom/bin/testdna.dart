import 'package:bloom/bloom.dart';

main() {

  Dna dna = new Dna(64);
  print(dna.length());
  print(dna);
  var app = dna.appender();
  int i = 0;
  while (app.canAppend()) {
    app.append(true);
    i++;
  }

  print(i);
  print(dna);
}
