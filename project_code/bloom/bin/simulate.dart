import 'package:bloom/bloom.dart';
import 'package:image/image.dart';
import 'dart:math';
import 'dart:io';

main() {
  
  Random rng = new Random();
  Simulator sim = new Simulator(rng,5,5,20);
  sim.initialise(12);
  for ( int i = 0; i < 5000; i++ ) {
    if ( i % 100 == 0 || (i - 5) % 100 == 0) {
      List<Pot> ma = sim.collectable();
      if ( ma.isNotEmpty ) {
        sim.pollinate( ma[rng.nextInt(ma.length)]);
      }
    }
    if ( (i - 10) % 100 == 0) {
      List<Pot> em = sim.empties();
      if ( em.isNotEmpty ) {
        sim.pollinate( em[rng.nextInt(em.length)]);
      }
    }
    write( sim.render(), i, "sim5");
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