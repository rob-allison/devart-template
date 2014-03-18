import 'package:bloom/bloom.dart';
import 'package:image/image.dart';
import 'dart:math';
import 'dart:io';

main() {

  var setting = [[25, 9, 1], [250, 4, 0], [60, 4, 0]][0];

  Random rng = new Random();
  RandomDna rdna = new RandomDna(rng, 64);
  
  for (int j = 0; j < 1; j++) {
    Flower flower = new Flower(rng, [rdna.build(), rdna.build(), new Dna.ofLength(64), rdna.build()]);
    for (int i = 0; i < setting[0]; i++) {
      render(setting,"test",flower, i);
      flower = flower.grow();
    }
    //render(setting, "flowers", flower, j);
  }

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
