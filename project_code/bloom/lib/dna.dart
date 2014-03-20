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
    List<Protein> proteins = new List( );
    int i = 0;
    Protein p = new Protein();
    CodonIterator iter = codonIterator;
    while ( iter.moveNext() ) {
      p.acids[i] = iter.current.decode();
      i++;
      if ( i == Protein.length ) {
        proteins.add(p);
        i = 0;
        p = new Protein( );
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
  Acid( this.value);
  
  String toString( ) {
    return value.toRadixString(16);
  }
}

class Protein {
  static final int length = 32;
  final List<Acid> acids;
  Protein( ) : acids = new List(length);
  
  int evaluate() {
    int sum = 0;
    acids.forEach((a){
      sum += a.value;
    });
    sum += 16;
    return sum ~/ 2;
  }
  
  String toString( ) {
    StringBuffer sb = new StringBuffer();
    acids.forEach((a){
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

List<Dna> breed(Random rng, RandomDna rdna, List<Dna> a, List<Dna> b) {

  List<Dna> result = new List(a.length);
  for ( int i = 0; i < a.length; i++ ) {
    int x = rng.nextInt(100);
    if ( x < 40 ) {
      result[i] = a[i];
    }
    if ( x < 80 ) {
      result[i] = b[i];
    }
    else {
      result[i] = intermingle(rng, a[i], b[i]);
    }
  }
  
  // mutate
  if (rng.nextInt(100) < 10) {
    int i = rng.nextInt(result.length);
    result[i] = mutate( rng, result[i]);
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

Dna mutate( Random rng, Dna dna ) {
  Dna result = dna.copy();
  int factor = 4;
  int offset = rng.nextInt(dna.length );
  int window = rng.nextInt(dna.length ~/ factor );
  bool b = rng.nextBool();
  CircularList<bool> cl = new CircularList(result, offset );
  for ( int i = 0; i < cl.length; i++ ) {
    cl[i] = b;
  }
  return result;
}


Dna intermingle(Random rng, Dna a, Dna b ) {
  Dna result = new Dna.ofLength(a.length);
  for (int i = 0; i < a.sequence.bytes.length; i++) {
    int amask = rng.nextInt(256);
    int bmask = ~amask;
    int apart = a.sequence.bytes[i] & amask;
    int bpart = b.sequence.bytes[i] & bmask;
    result.sequence.bytes[i] = apart | bpart;
  }
  return result;
}


