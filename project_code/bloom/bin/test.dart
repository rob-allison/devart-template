import 'package:bloom/bloom.dart';
import 'package:image/image.dart';
import 'dart:io';

main() {
  /*
  Plane pl = new Plane(0);
  pl.put(0, 0, getColor(100,50,100));
  Image im = pl.render(20);

  List<int> png = encodePng(im);
  new File('/home/rob/test/test.png')..writeAsBytesSync(png);
  */
  
  List<int> colours = new List<int>( );
  for ( int j = 0; j < 250; j = j + 5 ) {
    colours.add(getColor(100,j,100));
  }
  
  CentreGrowth cg = new CentreGrowth(colours.iterator);
  int i = 0;
  while ( cg.moveNext() ) {
    Plane pl = cg.current;
    Image im = pl.render(52,10);
    List<int> png = encodePng(im);
    String istr = i.toString();
    if ( i < 10 ) {
      istr = "0" + istr;
    }
    new File('/home/rob/test/img$istr.png')..writeAsBytesSync(png);
    i++;
  }
}
