import 'package:bloom/bloom.dart';
import 'package:image/image.dart';
import 'dart:math';
import 'dart:io';

main() {
  
  Random rng = new Random();
  RandomDna rdna = new RandomDna(rng, 512 );
  
  Dna a = rdna.build();
  Dna b = rdna.build();
  
  Dna dna = intermingle(rng, a, b);
  dna = mutate(rng, dna);
  dna = mutate(rng, dna);
  dna = mutate(rng, dna);
  dna = mutate(rng, dna);
  dna = smallmutate(rng, dna);
  
  print( dna );
  

  
  List<Protein> prots = dna.decode();
  
  int rd = prots[0].evaluate();
  int gn = prots[1].evaluate();
  int bl = prots[2].evaluate();
  
  print(rd.toString() + " " + gn.toString() + " " + bl.toString() );
  
  Image im = render( dna, 20, 1, getColor(255,255,255), getColor(rd,gn,bl) );
  List<int> png = encodePng(im);
  new File("/home/rob/bloom/singledna.png")..writeAsBytesSync(png);
}