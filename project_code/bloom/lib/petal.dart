part of bloom;

class Petal {

  final Random rng;
  final List<Dna> chromosomes;
  final int generation;
  final int age;
  final int marker;
  final BitList mask;
  int maskdeg;

  Petal(this.rng, this.chromosomes, this.generation, this.age, this.marker, this.mask) {
    maskdeg = decodeMaskDeg(chromosomes[2]);
  }

  Petal.start(this.rng, this.chromosomes, this.generation, this.marker)
      : age = 0,
        mask = new BitList.ofLength(128) {
    maskdeg = decodeMaskDeg(chromosomes[2]);
  }

  Petal grow() {
    BitList dmask = mask.copy();
    
    for ( int i = 0; i < maskdeg; i++ ) {
      dmask[rng.nextInt(dmask.length)] = true;
    }
    
    return new Petal(rng, chromosomes, generation, age + 1, marker, dmask);
  }

  Petal divide() {
    return new Petal(rng, chromosomes, generation, age, marker, mask);
  }

  int toColour() {

    Dna inner = chromosomes[0];
    Dna outer = chromosomes[1];
    //Dna mask = chromosomes[2];

    //Dna col = cross(inner, outer, mask.sequence);
    /*
    Dna col = new Dna( inner.length() );
    for ( int i = 0; i < age; i++ ) {
      col[i] = outer[i];
    }
    for ( int i = age; i < inner.length(); i++ ) {
      col[i] = inner[i];
    }*/

    //print(mask);

    //return dnaToColour(col);
    /*
    switch (marker) {
      case 0:
        return getColor(100, 0, 0);
        break;
      case 1:
        return getColor(100, 100, 0);
        break;
      case 2:
        return getColor(0, 100, 0);
        break;
      case 3:
        return getColor(0, 0, 100);
        break;
    }

    throw "not reachable";*/

    Iterator<Codon> itera = chromosomes[0].codonIterator;
    Iterator<Codon> iterb = chromosomes[1].codonIterator;
    Iterator<bool> iterm = mask.iterator;

    List<int> proteins = new List();
    while (itera.moveNext()) {
      iterb.moveNext();
      iterm.moveNext();
      proteins.add(iterm.current ? itera.current.decode() :
          iterb.current.decode());
    }

    return formColour(proteins.iterator);
  }

  void degenerate(Dna dna, int deg) {
    for (var iter = dna.modifyingIterator; iter.moveNext(); ) {
      if (rng.nextInt(512) < deg) {
        iter.current = true;
      }
    }
  }
}

int decodeMaskDeg(Dna dna) {
  Iterator<Codon> iter = dna.codonIterator;
  List<int> proteins = new List();
  while (iter.moveNext()) {
    proteins.add(iter.current.decode());
  }
  return 2 + formChannel(proteins.iterator) ~/ 64;
}

int decodeColour(Dna dna) {
  Iterator<Codon> iter = dna.codonIterator;
  List<int> proteins = new List();
  while (iter.moveNext()) {
    proteins.add(iter.current.decode());
  }
  return formColour(proteins.iterator);
}


int formColour(Iterator<int> iter) {
  int r = formChannel(iter);
  int g = formChannel(iter);
  int b = formChannel(iter);
  return getColor(r, g, b);
}

int formChannel(Iterator<int> iter) {
  int sum = 0;
  for (int i = 0; i < 32; i++) {
    iter.moveNext();
    sum += iter.current;
  }
  sum += 16;
  return sum ~/ 2;
}
