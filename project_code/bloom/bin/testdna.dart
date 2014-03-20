import 'package:bloom/bloom.dart';
import 'package:image/image.dart';
import 'dart:math';
import 'dart:io';

main() {

  RandomDna rdna = new RandomDna( new Random(), 512, 50 );
  var dnas = new List<Dna>( );
  for ( int i = 0; i < 1000; i++ ) {
    dnas.add(rdna.build());
  }
  
  dnas.sort((a, b) => decodeColour(a).compareTo(decodeColour(b)));
  
  Chromosomes ch = new Chromosomes(dnas);
  Image im = ch.render(1, 1, 0, getColor(255, 255, 255), getColor(0, 0, 0));
  List<int> png = encodePng(im);
  new File("/home/rob/chromosomes/img001.png")..writeAsBytesSync(png);
}

class Chromosomes extends ListBase<Dna> {
  final List<Dna> chromosomes;

  Chromosomes(this.chromosomes);

  Dna operator [](int i) => chromosomes[i];

  void operator []=(int i, Dna value) {
    chromosomes[i] = value;
  }

  int get length => chromosomes.length;

  void set length(int length) => throw "unmodifiable length";

  Image render(int w, int d, int gap, int white, int black) {
    Image image = new Image((w + gap) * chromosomes.length - gap, d *
        chromosomes[0].length);

    int x = 0;
    chromosomes.forEach((dna) {
      int y = 0;
      dna.forEach((b) {
        image = fillRect(image, x, y, x + w, y + d, b ? decodeColour(dna) :
            white);
        y = y + d;
      });
      x = x + w + gap;
    });
    return image;
  }
}
