import 'package:unittest/unittest.dart';
import 'package:bloom/bloom.dart';

void main() {

  test("zero dna", () {
    expect(new Dna.ofLength(16).toString(), equals("0000000000000000"));
  });

  test("string dna", () {
    expect(new Dna.fromString("1000011001001000").toString(), equals(
        "1000011001001000"));
  });

  test("set", () {
    Dna dna = new Dna.ofLength(16);
    dna[0] = true;
    dna[5] = true;
    dna[9] = true;
    dna[10] = true;
    dna[10] = false;
    expect(dna.toString(), equals("1000010001000000"));
  });

  test("get", () {
    Dna dna = new Dna.ofLength(16);
    dna[0] = true;
    dna[5] = true;
    dna[9] = true;
    expect(dna[0], equals(true));
    expect(dna[1], equals(false));
    expect(dna[5], equals(true));
    expect(dna[10], equals(false));
  });

  test("iterator", () {
    Dna dna = new Dna.ofLength(16);
    var iter = dna.modifyingIterator;
    iter.moveNext();
    iter.moveNext();
    iter.current = true;
    iter.moveNext();
    iter.moveNext();
    iter.moveNext();
    iter.moveNext();
    iter.moveNext();
    iter.moveNext();
    iter.moveNext();
    iter.moveNext();
    iter.moveNext();
    iter.moveNext();
    iter.current = true;
    expect(dna.toString(), equals("0100000000010000"));
  });
/*
  test("sum/avg", () {
    Dna dna = new Dna.ofLength(16);
    dna[0] = true;
    dna[5] = true;
    dna[9] = true;
    dna[10] = true;
    
    
    expect(dna.sum, equals(4));
    expect(dna.average, equals(0.25));
  });*/
}
