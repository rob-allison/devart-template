part of bloom;

class Petal {

  final List<Dna> chromosomes;
  final int generation;
  final int age;
  final int marker;

  Petal(this.chromosomes, this.generation, this.marker): age = 0;

  Petal._internal(this.chromosomes, this.generation, this.marker, this.age);

  Petal grow() {
    return new Petal._internal(chromosomes, generation, marker, age + 1);
  }

  Petal divide() {
    return new Petal._internal(chromosomes, generation, marker, age);
  }

  int toColour() {
    return getColor(100, marker * 50, 100);
  }
}
