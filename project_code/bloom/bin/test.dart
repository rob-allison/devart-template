import 'package:bloom/bloom.dart';
import 'package:image/image.dart';
import 'dart:io';

main() {

  var setting = [[25,9,1],[250,4,0]][1];
  
  Flower flower = new Flower([]);
  for (int i = 0; i < setting[0]; i++) {
    Image im = flower.render(setting[0], setting[1], setting[2]);
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
