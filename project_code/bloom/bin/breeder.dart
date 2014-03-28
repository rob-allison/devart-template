import 'package:bloom/bloom.dart';
import 'package:image/image.dart';
import 'dart:math';
import 'dart:io';

main() {
  Random rng = new Random();
  RandomDna rdna = new RandomDna(rng, 512);

  List<List<Dna>> dnas = new List();
  int f = 0;
  for (int j = 0; j < 5; j++) {
    List<Dna> dna = [rdna.build(), rdna.build(), rdna.build()];
    writeFlower(rng, f++, dna);
    dnas.add(dna);
  }

  for (int i = 0; i < 500; i++) {
    int x = rng.nextInt(dnas.length);
    int y = x;
    while (y == x) {
      y = rng.nextInt(dnas.length);
    }
    List<Dna> dna = breed(rng, dnas[x], dnas[y]);
    writeFlower(rng, f++, dna);
    if ( dnas.length == 10 ) dnas.removeAt(rng.nextInt(dnas.length));
    dnas.add(dna);
  }
}

void writeFlower(Random rng, int f, List<Dna> dna) {
  Flower flower = new Flower.start(rng, dna);
  while (flower.radius < 64) {
    flower = flower.grow();
  }
  Image im = flower.render( 64, 1);
  write(im, f, "pops2");
}

void write(Image im, int f, String dir) {
  List<int> png = encodePng(im);
  String istr = f.toString();
  if (f < 10) {
    istr = "0" + istr;
  }
  if (f < 100) {
    istr = "0" + istr;
  }
  new File("/home/rob/$dir/img$istr.png")..writeAsBytesSync(png);
}
