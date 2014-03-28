import 'package:bloom/bloom.dart';
import 'package:image/image.dart';
import 'dart:math';
import 'dart:io';

main(List<String> args) {

  String dir = args[0];
  Random rng = new Random();
  RandomDna rdna = new RandomDna(rng, 512);
  
  print("creating initial population...");
  List<List<Dna>> dnas = new List();
  int f = 0;
  for (int i = 0; i < 10; i++) {
    List<Dna> dna = [rdna.build(), rdna.build(), rdna.build()];
    grow(rng, dna, f++, dir);
    dnas.add(dna);
  }

  print("now grow your own:");
  int a = 0;
  int b = 1;
  int s = 0;
  print("enter parent# 0-" + (dnas.length - 1).toString());
  String line = stdin.readLineSync(retainNewlines: false);
  while (line != "q") {

    switch (s) {
      case 0:
        if (line != "") {
          a = int.parse(line);
        }
        s = 1;
        break;

      case 1:
        if (line != "") {
          b = int.parse(line);
        }
        List<Dna> dna = breed(rng, dnas[a], dnas[b]);
        grow(rng, dna, f++, dir);
        dnas.add(dna);
        s = 0;
        print("child grown.");
        break;
    }

    print("enter parent# 0-" + (dnas.length - 1).toString());
    line = stdin.readLineSync(retainNewlines: false);
  }
}

void grow(Random rng, List<Dna> dna, int f, String dir) {

  Flower flower = new Flower.start(rng, dna);
  for (int i = 0; i < 64; i++) {
    flower = flower.grow();
  }
  renderFlower(flower, f, dir);
}

renderDna(Flower flower, int i, String dir) {
  Image dim = flower.renderDna(10, 1, 0, getColor(255, 255, 255), getColor(0, 0,
      0));
  write(dim, i, dir);
}

renderFlower(Flower flower, int i, String dir) {
  Image fim = flower.render(64, 1, 0);
  write(fim, i, dir);
}

void write(Image im, int i, String dir) {
  List<int> png = encodePng(im);
  String istr = i.toString();
  if (i < 10) {
    istr = "0" + istr;
  }
  if (i < 100) {
    istr = "0" + istr;
  }
  new File("$dir/img$istr.png")..writeAsBytesSync(png);
}
