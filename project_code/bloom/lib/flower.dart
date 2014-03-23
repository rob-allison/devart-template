part of bloom;

class Flower {
  
  final Random rng;
  final List<Dna> chromosomes;
  final int radius;
  final Map<Point, Petal> petals = new Map();

  Flower.start(this.rng, this.chromosomes)
      : radius = 0;

  Flower(this.rng, this.chromosomes, this.radius);

  Image render(int r, int dpb, [int gap = 0]) {
    int side = r * 2 * (dpb + gap);
    Image image = new Image(side, side);
    return renderOn(image, r, r, dpb);
  }
  
  Image renderOn(Image image, int x, int y, int dpb, [int gap = 0]) {
    petals.forEach((p, c) {
      int x1 = (x + p.x) * (dpb + gap);
      int x2 = x1 + dpb - 1;
      int y1 = (y + p.y) * (dpb + gap);
      int y2 = y1 + dpb - 1;
      image = fillRect(image, x1, y1, x2, y2, c.toColour());
    });
    return image;
  }
  
  Image renderDna(int w, int d, int gap, int white, int black) {
    Image image = new Image((w + gap) * chromosomes.length - gap, d *
        chromosomes[0].length);

    int x = 0;
    chromosomes.forEach((dna) {
      int y = 0;
      dna.forEach((b) {
        image = fillRect(image, x, y, x + w, y + d, b ? black :
            white);
        y = y + d;
      });
      x = x + w + gap;
    });
    return image;
  }

  Flower grow() {

    int r = radius + 1;
    Flower result = new Flower(rng, chromosomes, r);

    result.writeRing(1, [new Petal.start(rng, chromosomes, r, 0), new Petal.start(rng, chromosomes, r,
        1), new Petal.start(rng, chromosomes, r, 2), new Petal.start(rng, chromosomes, r, 3)]);

    for (int i = 1; i <= radius; i++) {
      List<Petal> ring = readRing(i);
      List<Petal> bigger = growRing(i, ring);
      result.writeRing(i + 1, bigger);
    }

    return result;
  }

  List<Petal> growRing(int r, List<Petal> ring) {

    List<Petal> result = new List(ring.length + 8);

    List<int> divs;
    if (r == 1) {
      divs = [0,0,1,1,2,2,3,3];
    } else {
      divs = new List();
      for (int i = 0; i < 8; i++) {
        divs.add(rng.nextInt(ring.length));
      }
    }

    int offset = rng.nextInt(ring.length);
    List<Petal> cring = new CircularList(ring, offset, rng.nextBool());
    List<Petal> cresult = new CircularList.project(result, cring);
 
    int j = 0;
    for (int i = 0; i < cring.length; i++) {
      Petal ptl = cring[i];
      cresult[j] = ptl.grow();
      j++;
      for (int div in divs) {
        if (div == i) {
          cresult[j] = ptl.grow();
          j++;
        }
      }
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
