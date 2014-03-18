part of bloom;

class Petal {

  final Random rng;
  final List<Dna> chromosomes;
  final int generation;
  final int age;
  final int marker;

  Petal(this.rng, this.chromosomes, this.generation, this.marker): age = 0;

  Petal._internal(this.rng, this.chromosomes, this.generation, this.marker, this.age);

  Petal grow() {
    List<Dna> chroms = new List(4);
    chroms[0] = chromosomes[0];
    chroms[1] = chromosomes[1];
    Dna mask = chromosomes[2].copy();
    int deg = chromosomes[3].sum ~/ 16;
    degenerate(mask, deg);
    chroms[2] = mask;
    chroms[3] = chromosomes[3];
    return new Petal._internal(rng, chroms, generation, marker, age + 1);
  }

  Petal divide() {
    return new Petal._internal(rng, chromosomes, generation, marker, age);
  }

  int toColour() {

    Dna inner = chromosomes[0];
    Dna outer = chromosomes[1];
    Dna mask = chromosomes[2];

    Dna col = cross(inner, outer, mask.sequence);
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

    throw "not reachable";
  }

  void degenerate(Dna dna, int deg) {
    for (var iter = dna.modifyingIterator; iter.moveNext(); ) {
      if (rng.nextInt(512) < deg) {
        iter.current = true;
      } 
    }
  }
}

int dnaToColour(Dna dna) {
  int r = (dna.subSequence(0, dna.length ~/ 2).average * 255).toInt();
  int g = (dna.subSequence(dna.length ~/ 4, dna.length ~/ 2).average *
      255).toInt();
  int b = (dna.subSequence(dna.length ~/ 2, dna.length ~/ 2).average *
      255).toInt();
  //print( r.toString() + " " + g.toString() + " " + b.toString());
  return getColor(r, g, b);
}
