import 'package:bloom/bloom.dart';
import 'package:image/image.dart';
import 'dart:io';

main() {

  Flower flower = new Flower([]);
  for (int i = 0; i < 25; i++) {
    Image im = flower.render(25, 8, 2);
    List<int> png = encodePng(im);
    String istr = i.toString();
    if (i < 10) {
      istr = "0" + istr;
    }
    if (i < 100) {
      istr = "0" + istr;
    }
    new File('/home/rob/test/img$istr.png')..writeAsBytesSync(png);
    flower = flower.grow();
  }
}
