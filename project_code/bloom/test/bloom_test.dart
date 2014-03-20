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

  test("length", () {
    Dna dna = new Dna.ofLength(16);
    expect(dna.length, equals(16));
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
    var iter = dna.iterator;
    while (iter.moveNext()) {
      expect(iter.current, equals(false));
    }
  });

  test("modifying iterator", () {
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

  test("proteins", () {
    Dna dna = new Dna.fromString(BitList.clean(
        "1000011001001000 0100000000010000 0100000000010000 1101000101001111 0101011100110011 1100111010011100 0011001101110101 0100011100110111"
        ));
    List<Protein> proteins = dna.decode();
    expect(proteins.length, equals(1));
    Protein p = proteins[0];
    expect(p.toString(), equals("864840104010d14f5733ce9c33754737"));
    expect(p.evaluate(), equals(94));
  });
}
