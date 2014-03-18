import 'package:bloom/bloom.dart';
import 'package:image/image.dart';
import 'dart:math';
import 'dart:io';

main() {

  RandomDna rdna = new RandomDna( new Random(), 512 );
  var dnas = new List<Dna>( );
  for ( int i = 0; i < 50; i++ ) {
    dnas.add(rdna.build());
  }
  Chromosomes ch = new Chromosomes(dnas);
  Image im = ch.render(20, 1, 2, getColor(255, 255, 255), getColor(0, 0, 0));
  List<int> png = encodePng(im);
  new File("/home/rob/chromosomes/img001.png")..writeAsBytesSync(png);
}
