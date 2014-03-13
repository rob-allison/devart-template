part of bloom;

class Petal {

  final List<Dna> chromosomes;
  final int generation;
  final int age;

  Petal(this.chromosomes, this.generation): age = 0;

  Petal._internal(this.chromosomes, this.generation, this.age);

  Petal grow() {
    return new Petal._internal(chromosomes, generation, age + 1);
  }

  int toColour() {
    return getColor(100, age.toDouble() * 500 ~/ (generation * 10 + 1), 100);
  }
}
