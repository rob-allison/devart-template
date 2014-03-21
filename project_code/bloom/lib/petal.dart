part of bloom;

class Petal {

  final Random rng;
  final List<Dna> chromosomes;
  final int generation;
  final int age;
  final int marker;
  BitList mask;
  List<List<Protein>> proteins;
  int maskfactor;

  Petal(this.rng, this.chromosomes, this.generation, this.age, this.marker, this.mask, this.proteins, this.maskfactor);

  Petal.start(this.rng, this.chromosomes, this.generation, this.marker)
      : age = 0,
        mask = new BitList.ofLength(128) {

    proteins = new List();
    chromosomes.forEach((d) {
      proteins.add(d.decode());
    });

    maskfactor = getMaskFactor(proteins[2][0]);
    
    mask = deepenMask(rng, mask, (64 - generation) * maskfactor);
  }

  Petal grow() {
    BitList dmask = deepenMask(rng, mask, maskfactor );
    return new Petal(rng, chromosomes, generation, age + 1, marker, dmask,
        proteins, maskfactor);
  }

  Petal divide() {
    return new Petal(rng, chromosomes, generation, age, marker, mask, proteins,
        maskfactor);
  }

  int toColour() {
    Iterator<bool> iterm = mask.iterator;
    int r = getChannel(proteins[0][0], proteins[1][0], iterm);
    int g = getChannel(proteins[0][1], proteins[1][1], iterm);
    int b = getChannel(proteins[0][2], proteins[1][2], iterm);
    return getColor(r, g, b);
  }
}

BitList deepenMask(Random rng, BitList mask, int maskfactor ) {
  BitList dmask = mask.copy();
  for (int i = 0; i < maskfactor; i++) {
    dmask[rng.nextInt(dmask.length)] = true;
  }
  return dmask;
}

int getMaskFactor(Protein p) {
  int sum = 0;
  p.acids.forEach((a) {
    sum += a.value;
  });
  return 1 + (sum ~/ 128);
}

int getChannel(Protein inner, Protein outer, Iterator<bool> iterm) {
  int sum = 0;
  Iterator<Acid> iteri = inner.acids.iterator;
  Iterator<Acid> itero = outer.acids.iterator;
  while (iteri.moveNext()) {
    itero.moveNext();
    iterm.moveNext();
    sum += iterm.current ? iteri.current.value : itero.current.value;
  }
  return (sum + 16) ~/ 2;
}

