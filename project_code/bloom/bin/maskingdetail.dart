import 'package:bloom/bloom.dart';
import 'package:image/image.dart';
import 'dart:math';
import 'dart:io';

main() {

  Random rng = new Random();
  RandomDna rdna = new RandomDna(rng, 512);

  int j = 100;
  List<Protein> inner = [f0c307fe1fffc7fff00038001c001e84, 0c000fc0030000c003c007c00043e007, 000710f80078007c00400080fc0ff8ff, e3e007ff00803e300c003007803f07ff]
  
  [ff800008018078000f8780007f780002, 0000ffe5fffdfff70008f078787c0df0, 001f001e0bff21effdd87f1ffcf9f7ff, 1fff3ff8f8017f8fffc1ffffa083e1ff]
  12 
  List<Protein> outer = proteins(rdna, rng);
  print(j.toString() + " " + inner.toString() + " " + outer.toString());

  BitList mask = new BitList.ofLength(128);

  Image im = new Image(1000, 100);
  for (int i = 0; i < 99; i++) {
    int col = getColourFromProtein(inner, outer, mask);
    im = fillRect(im, i * 10, 0, (i * 10) + 10, 100, col);
    mask = deepenMask(rng, mask, 5);
  }
  im = fillRect(im, 99 * 10, 0, (99 * 10) + 10, 100, getColourFromProtein(outer,
      inner, new BitList.ofLength(128)));

  List<int> png = encodePng(im);
  String jstr = j.toString();
  new File("/home/rob/masking/img$jstr.png")..writeAsBytesSync(png);


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
