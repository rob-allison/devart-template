import 'package:bloom/bloom.dart';
import 'package:image/image.dart';
import 'dart:math';
import 'dart:io';

main() {

  var setting = [[25, 9, 1], [250, 4, 0], [60, 4, 0], [64, 1, 0]][3];

  Random rng = new Random();
  RandomDna rdna = new RandomDna(rng, 512);

  int f = 0;

  for (int i = 0; i < 10; i++) {
    Dna a0 = rdna.build();
    Dna a1 = rdna.build();
    Dna a2 = rdna.build();
    Dna b0 = rdna.build();
    Dna b1 = rdna.build();
    Dna b2 = rdna.build();

    List<Dna> dnaa = [a0, a1, a2];
    List<Dna> dnab = [b0, b1, b2];

    grow(rng, dnaa, setting, f);
    f++;
    grow(rng, dnab, setting, f);
    f++;

    List<Dna> dnac;
    
    dnac = [a0, a1, b2];
    grow(rng, dnac, setting, f);
    f++;

    dnac = [a0, b1, a2];
    grow(rng, dnac, setting, f);
    f++;

    dnac = [a0, b1, b2];
    grow(rng, dnac, setting, f);
    f++;

    dnac = [b0, a1, a2];
    grow(rng, dnac, setting, f);
    f++;

    dnac = [b0, a1, b2];
    grow(rng, dnac, setting, f);
    f++;
    
    dnac = [b0, b1, a2];
    grow(rng, dnac, setting, f);
    f++;
  }

}

void grow(Random rng, List<Dna> dnaa, setting, int f) {

  Flower flower = new Flower.start(rng, dnaa);
  for (int i = 0; i < setting[0]; i++) {
    //render(setting,"test",flower, i);
    flower = flower.grow();
  }
  render(setting, "flowers", flower, f);

}

render(var setting, var dir, Flower flower, int i) {
  Image im = flower.render(setting[0], setting[1], setting[2]);
  List<int> png = encodePng(im);
  String istr = i.toString();
  if (i < 10) {
    istr = "0" + istr;
  }
  if (i < 100) {
    istr = "0" + istr;
  }
  new File("/home/rob/" + dir + "/img$istr.png")..writeAsBytesSync(png);
}
