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
