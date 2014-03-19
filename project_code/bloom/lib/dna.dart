part of bloom;

class Dna extends ListBase<bool> {

  final BitList sequence;

  Dna(this.sequence);

  Dna.fromString(String str): sequence = new BitList.fromString(str);

  Dna.ofLength(int length): sequence = new BitList.ofLength(length);

  bool operator [](int i) => sequence[i];

  void operator []=(int i, bool value) {
    sequence[i] = value;
  }

  int get length => sequence.length;

  void set length(int length) => throw "unmodifiable length";

  Iterator<bool> get modifyingIterator => new ModifyingIterator(this);

  Dna copy() {
    return new Dna(sequence.copy());
  }

  Iterator<Codon> get codonIterator {
    return new CodonIterator(this);
  }

  String toString() {
    return sequence.toString();
  }
}

class CodonIterator extends Iterator<Codon> {
  final Dna dna;
  int i = -Codon.length;

  CodonIterator(this.dna);

  Codon get current => new Codon(dna, i);

  bool moveNext() {
    i += Codon.length;
    return i < dna.length;
  }
}

class Codon {
  static final int length = 4;
  final Dna dna;
  final int offset;

  Codon(this.dna, this.offset);

  int decode() {
    int v = 0;
    for (int i = 0; i < length; i++) {
      v += dna[offset] ? pow(2, i) : 0;
    }
    return v;
  }
}

class RandomDna {

  final Random random;
  final int length;
  final int window;

  RandomDna(this.random, this.length, [this.window = 180]);

  Dna build() {
    Dna dna = new Dna.ofLength(length);
    int n = random.nextInt(window);
    bool b = random.nextBool();
    int i = 0;
    for (var iter = dna.modifyingIterator; iter.moveNext(); ) {
      iter.current = b;
      if (i == n) {
        n += 1 + random.nextInt(window);
        b = random.nextBool();
      }
      i++;
    }
    return dna;
  }
}

List<Dna> breed(List<Dna> a, List<Dna> b) {


  Random rng = new Random();

  bool r1 = true;
  bool r2 = true;
  bool r3 = true;
  
  while (r1 == r2 && r2 == r3) {
    r1 = rng.nextBool();
    r2 = rng.nextBool();
    r3 = rng.nextBool();
  }
  
  var result = new List<Dna>();
  result.add(r1 ? a[0] : b[0]);
  result.add(r2 ? a[1] : b[1]);
  result.add(r3 ? a[2] : b[2]);
  
  if (rng.nextInt(4) == 0) {
    int i = rng.nextInt(result.length);
    int j = rng.nextInt(result.length);
    Dna x = result[i];
    result[i] = result[j];
    result[j] = x;
  }

  return result;
}


Dna cross(Dna a, Dna b, ByteList mask) {
  Dna result = new Dna.ofLength(a.length);
  for (int i = 0; i < a.sequence.bytes.length; i++) {
    int amask = mask[i];
    int bmask = ~mask[i];
    int apart = a.sequence.bytes[i] & amask;
    int bpart = b.sequence.bytes[i] & bmask;
    result.sequence.bytes[i] = apart | bpart;
  }
  return result;
}

class Chromosomes extends ListBase<Dna> {
  final List<Dna> chromosomes;

  Chromosomes(this.chromosomes);

  Dna operator [](int i) => chromosomes[i];

  void operator []=(int i, Dna value) {
    chromosomes[i] = value;
  }

  int get length => chromosomes.length;

  void set length(int length) => throw "unmodifiable length";

  Image render(int w, int d, int gap, int white, int black) {
    Image image = new Image((w + gap) * chromosomes.length - gap, d *
        chromosomes[0].length);

    int x = 0;
    chromosomes.forEach((dna) {
      int y = 0;
      dna.forEach((b) {
        image = fillRect(image, x, y, x + w, y + d, b ? decodeColour(dna) :
            white);
        y = y + d;
      });
      x = x + w + gap;
    });
    return image;
  }
}
