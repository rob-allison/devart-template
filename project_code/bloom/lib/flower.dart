part of bloom;

class Flower {

  final List<Dna> chromosomes;
  final int radius;
  final Map<Point, Petal> petals = new Map();

  Flower(this.chromosomes): radius = 0;

  Flower._internal(this.chromosomes, this.radius);

  Image render(int r, int dpb) {
    int side = r * 2 * dpb;
    Image image = new Image(side, side);
    petals.forEach((p, c) {
      int x1 = (r + p.x) * dpb;
      int x2 = x1 + dpb;
      int y1 = (r + p.y) * dpb;
      int y2 = y1 + dpb;
      image = fillRect(image, x1, y1, x2, y2, c.toColour());
    });
    return image;
  }

  Flower grow() {

    int r = radius + 1;
    Flower result = new Flower._internal(chromosomes, r);

    result.writeRing(1, [new Petal(chromosomes, r), new Petal(chromosomes, r),
        new Petal(chromosomes, r), new Petal(chromosomes, r)]);

    for (int i = 1; i <= radius; i++) {
      List<Petal> ring = readRing(i);
      List<Petal> bigger = growRing(i, ring);
      result.writeRing(i + 1, bigger);
    }

    return result;
  }

  List<Petal> growRing(int r, List<Petal> ring) {

    List<Petal> result = new List();
    for (Petal pet in ring) {
      result.add(pet.grow());
    }

    for (int i = 0; i < 8; i++) {
      result.add(ring[0].grow());
    }

    return result;
  }

  List<Petal> readRing(int r) {
    List<Petal> result = new List();
    for (Point p in generateRingPoints(r)) {
      result.add(petals[p]);
    }
    return result;
  }

  void writeRing(int r, List<Petal> ring) {
    int i = 0;
    for (Point p in generateRingPoints(r)) {
      petals[p] = ring[i];
      i++;
    }
  }
}
