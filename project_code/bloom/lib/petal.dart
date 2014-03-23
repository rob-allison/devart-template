part of bloom;

class Petal {

  final Random rng;
  final List<Dna> chromosomes;
  final int generation;
  final int age;
  final int marker;
  BitList mask;
  List<List<Protein>> proteins;
  int agemaskfactor;
  int genmaskfactor;

  Petal(this.rng, this.chromosomes, this.generation, this.age, this.marker, this.mask, this.proteins, this.agemaskfactor, this.genmaskfactor);

  Petal.start(this.rng, this.chromosomes, this.generation, this.marker)
      : age = 0,
        mask = new BitList.ofLength(128) {

    proteins = new List();
    chromosomes.forEach((d) {
      proteins.add(d.decode());
    });

    agemaskfactor = getMaskFactor(proteins[2][0]);
    genmaskfactor = getMaskFactor(proteins[2][1]);
    
    mask = deepenMask(rng, mask, (64 - generation) * genmaskfactor);
  }

  Petal grow() {
    BitList dmask = deepenMask(rng, mask, agemaskfactor );
    return new Petal(rng, chromosomes, generation, age + 1, marker, dmask,
        proteins, agemaskfactor, genmaskfactor);
  }

  Petal divide() {
    return new Petal(rng, chromosomes, generation, age, marker, mask, proteins,
        agemaskfactor,genmaskfactor);
  }
  
  int toColour( ) {
    return getColourFromProtein(proteins[0], proteins[1], mask);
  }
}

BitList deepenMask(Random rng, BitList mask, int maskfactor ) {
  BitList dmask = mask.copy();
  for (int i = 0; i < maskfactor; i++) {
    dmask[rng.nextInt(dmask.length)] = true;
  }
  return dmask;
}

int getColourFromProtein( List<Protein> inner, List<Protein> outer, BitList mask ) {
  int r = getChannel(inner[0], outer[0], mask, 0);
  int g = getChannel(inner[1], outer[1], mask, 32);
  int b = getChannel(inner[2], outer[2], mask, 64);
  return getColor(r, g, b);
}

int getMaskFactor(Protein p) {
  int sum = 0;
  p.acids.forEach((a) {
    sum += a.value;
  });
  return 1 + (sum ~/ 128);
}

int getChannel(Protein inner, Protein outer, BitList mask, int moffset ) {
  
  Protein comb = new Protein( );
  for ( int i = 0; i < Protein.length; i++ ) {
    comb.acids[i] = mask[moffset + i] ? inner.acids[i] : outer.acids[i];
  }
  return comb.evaluate();
}

