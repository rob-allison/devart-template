import 'package:bloom/bloom.dart';
import 'package:image/image.dart';
import 'dart:math';
import 'dart:io';

main() {
  
  Random rng = new Random();
  RandomDna rdna = new RandomDna(rng, 512 );
  
  for ( int j = 0; j < 20; j++ ) {
    List<Protein> inner = proteins(rdna, rng);
    List<Protein> outer = proteins(rdna, rng);
    print( j.toString() + " " + inner.toString() + " " + outer.toString() );
    
    BitList mask = new BitList.ofLength(128);
    
    Image im = new Image(1000, 100);
    for ( int i = 0; i < 99; i++ ) {
      int col = getColourFromProtein(inner, outer, mask);
      im = fillRect(im, i * 10, 0, (i * 10) + 10, 100, col);
      mask = deepenMask(rng, mask, 5);
    }
    im = fillRect(im, 99 * 10, 0, (99 * 10) + 10, 100, getColourFromProtein(outer, inner, new BitList.ofLength(128)));
    
    List<int> png = encodePng(im);
    String jstr = j.toString();
    new File("/home/rob/masking/img$jstr.png")..writeAsBytesSync(png);
  }
  
}

List<Protein> proteins(RandomDna rdna, Random rng) {
  Dna a = rdna.build();
  Dna b = rdna.build();
  
  Dna dna = intermingle(rng, a, b);
  dna = mutate(rng, dna);
  dna = mutate(rng, dna);
  dna = mutate(rng, dna);
  dna = mutate(rng, dna);
  dna = smallmutate(rng, dna);
  
  List<Protein> prots = dna.decode();
  return prots;
}