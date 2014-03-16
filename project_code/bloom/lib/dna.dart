part of bloom;

class Dna {

  final ByteData sequence;

  Dna(int length): sequence = new ByteData(length);

  Dna._internal(this.sequence);

  int operator [](int i) => sequence.getUint8(i);

  void operator []=(int i, int value) {
    sequence.setUint8(i, value);
  }

  Appender<bool> appender() {
    return new DnaAppender(this);
  }

  Dna copy() {
    Dna cpy = new Dna(length());
    for (int i = 0; i < length(); i++) {
      cpy[i] = this[i];
    }
    return cpy;
  }

  Dna subSequence(int offset, int length) {
    return new Dna._internal(new ByteData.view(sequence.buffer, offset, length)
        );
  }

  int length() {
    return sequence.lengthInBytes;
  }

  int sum() {
    int s = 0;
    for (int i = 0; i < length(); i++) {
      int b = this[i];
      s += bits(b);
    }
    return s;
  }

  double average() {
    return sum().toDouble() / (length().toDouble() * 8.toDouble());
  }

  String toString() {
    String result = "";
    for (int i = 0; i < length(); i++) {
      String s = this[i].toRadixString(2);
      while (s.length < 8) {
        s = "0" + s;
      }
      result += s;
    }
    return result;
  }
}

abstract class Appender<E> {
  void append(E e);
  void skip();
  bool canAppend();
}

class RandomDna {

  final Random random;
  final int length;
  final int window;

  RandomDna(this.random, this.length, [this.window = 180]);

  Dna build() {

    Dna dna = new Dna(length);
    int n = random.nextInt(window);
    bool b = random.nextBool();
    Appender<bool> appender = dna.appender();

    int i = 0;
    while (appender.canAppend()) {
      appender.append(b);
      if (i == n) {
        n += random.nextInt(window);
        b = random.nextBool();
      }
      i++;
    }
    return dna;
  }
}

class DnaAppender extends Appender<bool> {

  final Dna dna;
  int i = 0;
  int b = 0;

  DnaAppender(this.dna);

  void append(bool bit) {
    if (canAppend()) {
      if (bit) {
        dna[i] = dna[i] | 1 << b;
      } else {
        dna[i] = dna[i] & ~(1 << b);
      }

      skip();
    } else {
      throw "overflow";
    }
  }

  void skip() {
    if (canAppend()) {
      b++;
      if (b == 8) {
        i++;
        b = 0;
      }
    } else {
      throw "overflow";
    }
  }

  bool canAppend() {
    return i < dna.length();
  }
}

int bits(int b) {
  int bits = 0;
  for (int i = 0; i < 8; i++) {
    if ((b & (1 << i)) != 0) {
      bits++;
    }
  }
  return bits;
}

Dna cross(Dna a, Dna b, Dna mask) {
  Dna result = new Dna(a.length());
  for (int i = 0; i < a.length(); i++) {
    int amask = mask[i];
    int bmask = ~mask[i];
    int apart = a[i] & amask;
    int bpart = b[i] & bmask;
    result[i] = apart | bpart;
  }
  return result;
}
