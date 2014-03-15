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

  Petal divide() {
    return new Petal._internal(chromosomes, generation, age);
  }

  int toColour() {
    return getColor(100, age * 10, generation * 10);
  }
}
