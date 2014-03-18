part of bloom;

class Dna extends ListBase<bool> {

  final ByteList sequence;

  Dna(this.sequence);

  Dna.fromString(String str): sequence = new ByteList.ofLength(str.length ~/ 8)
      {
    for (int i = 0; i < str.length; i++) {
      this[i] = str[i] == "1"[0];
    }
  }

  Dna.ofLength(int length): sequence = new ByteList.ofLength(length ~/ 8);

  bool operator [](int i) => (sequence[i ~/ 8] & (1 << (i % 8))) != 0;

  void operator []=(int i, bool value) {
    sequence[i ~/ 8] = value ? sequence[i ~/ 8] | (1 << (i % 8)) : sequence[i ~/
        8] & ~(1 << (i % 8));
  }

  int get length => sequence.length * 8;

  void set length(int length) => throw "unmodifiable length";

  Iterator<bool> get modifyingIterator => new DnaIterator(this);

  Dna copy() {
    Dna cpy = new Dna.ofLength(length);
    for (int i = 0; i < length; i++) {
      cpy[i] = this[i];
    }
    return cpy;
  }

  Dna subSequence(int offset, int length) {
    return new Dna(new ByteList(new ByteData.view(sequence.bytes.buffer, offset
        ~/ 8, length ~/ 8)));
  }

  int get sum {
    int s = 0;
    sequence.forEach((b) {
      int bits = 0;
      for (int i = 0; i < 8; i++) {
        if ((b & (1 << i)) != 0) {
          bits++;
        }
      }
      s += bits;
    });
    return s;
  }

  double get average {
    return sum.toDouble() / length.toDouble();
  }

  String toString() {
    String result = "";
    this.forEach((b) {
      result += b ? "1" : "0";
    });
    return result;
  }
}

class DnaIterator extends Iterator<bool> {
  final Iterator iter;
  final Dna dna;
  int i = -1;

  DnaIterator(Dna dna)
      : this.dna = dna,
        iter = dna.iterator;

  bool moveNext() {
    if (iter.moveNext()) {
      i++;
      return true;
    } else {
      return false;
    }
  }

  bool get current => iter.current;

  void set current(bool b) {
    dna[i] = b;
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

Dna cross(Dna a, Dna b, ByteList mask) {
  Dna result = new Dna.ofLength(a.length);
  for (int i = 0; i < a.sequence.length; i++) {
    int amask = mask[i];
    int bmask = ~mask[i];
    int apart = a.sequence[i] & amask;
    int bpart = b.sequence[i] & bmask;
    result.sequence[i] = apart | bpart;
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
        image = fillRect(image, x, y, x + w, y + d, b ? dnaToColour(dna) : white
            );
        y = y + d;
      });
      x = x + w + gap;
    });
    return image;
  }
}
