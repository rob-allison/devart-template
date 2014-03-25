import 'package:bloom/bloom.dart';
import 'package:image/image.dart';
import 'dart:io';

main() {
  
  Simulator sim = new Simulator(5,5,20);
  sim.initialise(12);
  for ( int i = 0; i < 5000; i++ ) {
    if ( i % 50 == 0 ) sim.pollinate( );
    write( sim.render(), i, "sim3");
  }
}

void write(Image im, int i, String dir) {
  List<int> png = encodePng(im);
  String istr = i.toString();
  if (i < 10) {
    istr = "0" + istr;
  }
  if (i < 100) {
    istr = "0" + istr;
  }
  if (i < 1000) {
    istr = "0" + istr;
  }
  new File("/home/rob/$dir/img$istr.png")..writeAsBytesSync(png);
}