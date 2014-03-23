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

  List<Protein> decode() {
    List<Protein> proteins = new List();
    int i = 0;
    Protein p = new Protein();
    CodonIterator iter = codonIterator;
    while (iter.moveNext()) {
      p.acids[i] = iter.current.decode();
      i++;
      if (i == Protein.length) {
        proteins.add(p);
        i = 0;
        p = new Protein();
      }
    }
    return proteins;
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

  Acid decode() {
    int v = 0;
    for (int i = 0; i < length; i++) {
      v += dna[offset + i] ? pow(2, length - 1 - i) : 0;
    }
    return new Acid(v);
  }
}

class Acid {
  final int value;
  Acid(this.value);

  String toString() {
    return value.toRadixString(16);
  }
}

class Protein {
  static final int length = 32;
  final List<Acid> acids;
  Protein(): acids = new List(length);

  int evaluate() {
    int sum = 0;
    acids.forEach((a) {
      sum += a.value;
    });
    sum += 16;
    return sum ~/ 2;
  }

  String toString() {
    StringBuffer sb = new StringBuffer();
    acids.forEach((a) {
      sb.write(a.toString());
    });
    return sb.toString();
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

List<Dna> breed(Random rng, List<Dna> a, List<Dna> b) {

  List<Dna> result = new List(a.length);
  for (int i = 0; i < a.length; i++) {
    int x = rng.nextInt(100);
    if (x < 40) {
      result[i] = a[i];
    } else if (x < 80) {
      result[i] = b[i];
    } else {
      result[i] = intermingle(rng, a[i], b[i]);
    }
  }

  // mutate
  if (rng.nextInt(100) < 10) {
    int i = rng.nextInt(result.length);
    result[i] = mutate(rng, result[i]);
  }

  // swap
  if (rng.nextInt(100) < 10) {
    int i = rng.nextInt(result.length);
    int j = rng.nextInt(result.length);
    Dna x = result[i];
    result[i] = result[j];
    result[j] = x;
  }

  return result;
}

Dna mutate(Random rng, Dna dna) {
  Dna result = dna.copy();
  int factor = 4;
  int offset = rng.nextInt(dna.length);
  int window = rng.nextInt(dna.length ~/ factor);
  bool b = rng.nextBool();
  CircularList<bool> cl = new CircularList(result, offset);
  for (int i = 0; i < window; i++) {
    cl[i] = b;
  }
  return result;
}

Dna smallmutate(Random rng, Dna dna) {
  Dna result = dna.copy();
  int n = rng.nextInt(20);
  int w = rng.nextInt(5) + 1;
  for (int i = 0; i < result.length; i++) {
    if (i > n - w) {
      result[i] = !result[i];
    }

    if (i == n) {
      n = n + rng.nextInt(20) + 1;
      w = rng.nextInt(5) + 1;
    }
  }
  return result;
}


Dna intermingle(Random rng, Dna a, Dna b) {

  int window = 20;
  Dna result = new Dna.ofLength(a.length);
  int n = rng.nextInt(window);
  bool f = rng.nextBool();
  int i = 0;
  for (var iter = result.modifyingIterator; iter.moveNext(); ) {
    iter.current = f ? a[i] : b[i];
    if (i == n) {
      n += 1 + rng.nextInt(window);
      f = rng.nextBool();
    }
    i++;
  }

  return result;
}

Image render(Dna dna, int w, int d, int white, int black) {
  Image image = new Image(w, d * dna.length);
  return renderOn(dna, image, 0, 0, w, d, white, black);
}

Image renderOn(Dna dna, Image image, int x, int y, int w, int d, int white, int
    black) {
  dna.forEach((b) {
    image = fillRect(image, x, y, x + w, y + d, b ? black : white);
    y = y + d;
  });
  return image;
}
