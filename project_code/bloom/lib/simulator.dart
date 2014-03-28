part of bloom;

class Simulator {

  final Random rng;
  final List<Pot> pots = new List();
  final int xdim;
  final int ydim;
  final int gap;
  final List<Pollination> pollinations = new List();

  Simulator(this.rng, this.xdim, this.ydim, this.gap) {
    for (int i = 0; i < xdim; i++) {
      for (int j = 0; j < ydim; j++) {
        pots.add(new Pot(gap + (i * (128 + gap)) + 64, gap + (j * (128 + gap)) +
            64));
      }
    }
  }

  void initialise(int n) {
    RandomDna rdna = new RandomDna(rng, 512);
    for (int i = 0; i < n; i++) {
      Flower flower = new Flower.start(rng, [rdna.build(), rdna.build(),
                                                 rdna.build()]);
      pots[rng.nextInt(pots.length)].plant(flower, rng.nextInt(200));
    }
  }

  Image render() {
    int xside = (xdim * 128) + ((xdim + 1) * gap);
    int yside = (ydim * 128) + ((ydim + 1) * gap);
    Image image = new Image(xside, yside);
    fill(image, getColor(20, 20, 20));
    pots.forEach((pot) {
      image = pot.renderOn(image);
    });

    pollinations.removeWhere((r) => r.age > 64);
    pollinations.forEach((r) {
      image = r.renderOn(image);
    });

    return image;
  }

  void pollinate(Pot p) {
    if (pollinations.isEmpty) {
      if (p.isMature()) {
        Pollination pol = new Pollination();
        pol.p1 = p;
        pollinations.add(pol);
      }
    } else {
      Pollination last = pollinations.last;
      if (last.p2 == null) {
        if (p != last.p1 && p.isMature()) {
          last.p2 = p;
        }
      } else if (last.p3 == null) {
        if (p.isEmpty()) {
          last.p3 = p;
          List<Dna> dna1 = last.p1.collect();
          List<Dna> dna2 = last.p2.collect();
          List<Dna> dna = breed(rng, dna1, dna2);
          Flower flower = new Flower.start(rng, dna);
          last.p3.plant(flower);
        }
      } else {
        Pollination pol = new Pollination();
        pol.p1 = p;
        pollinations.add(pol);
      }
    }

    List<Pot> ma = matures();
    if (ma.length > xdim * ydim - 4) {
      int age = 0;
      Pot oldest = null;
      ma.forEach((m) {
        if (m.age > age) {
          age = m.age;
          oldest = m;
        }
      });
      if (oldest != null) {
        oldest.kill();
      }
    }
  }

  List<Pot> matures() {
    List<Pot> matures = new List();
    pots.forEach((p) {
      if (p.isMature()) {
        matures.add(p);
      }
    });
    return matures;
  }

  List<Pot> collectable() {
    List<Pot> coll = matures();
    if (pollinations.isNotEmpty) {
      if (pollinations.last.p2 == null) {
        coll.remove(pollinations.last.p1);
      }
    }
    return coll;
  }

  List<Pot> empties() {
    List<Pot> empty = new List();
    pots.forEach((p) {
      if (p.isEmpty()) {
        empty.add(p);
      }
    });
    return empty;
  }
}

class Pot {

  int longevity = 10000000;
  final int x;
  final int y;
  Flower flower;
  int age;

  Pot(this.x, this.y);

  Image renderOn(Image image) {
    if (flower != null) {
      if (flower.radius < 64) {
        flower = flower.grow();
        age++;
        image = fillRect(image, x - 64, y - 64, x + 63, y + 63, getColor(0, 0, 0
            ));
        return flower.renderOn(image, x, y, 1);
      } else if (age < longevity) {
        age++;
        return flower.renderOn(image, x, y, 1);
      } else if (age < longevity + 60) {
        age++;
        Image im = flower.render(64, 1);
        im = grayscale(im);
        im = brightness(im, 4 * (longevity - age));
        return copyInto(image, im, dstX: x - 64, dstY: y - 64, srcX: 0, srcY: 0,
            srcW: 128, srcH: 128);
      } else {
        flower = null;
        age = null;
      }
    }
    return fillRect(image, x - 64, y - 64, x + 63, y + 63, getColor(0, 0, 0));
  }

  Image renderDnaOn(Image image) {
    int w = 3;
    Image dim = flower.renderDna(w, 1, 0, getColor(255, 255, 255), getColor(0,
        0, 0));
    dim = copyResize(dim, 3 * w, 128);
    return copyInto(image, dim, dstX: x - 64, dstY: y - 64, srcX: 0, srcY: 0,
        srcW: 3 * w, srcH: 128);
  }

  List<Dna> collect() {
    if (flower != null) {
      if (flower.radius == 64) {
        return flower.chromosomes;
      }
    }
    return null;
  }

  bool isMature() {
    if (flower != null) {
      if (flower.radius == 64) {
        if (age < longevity) {
          return true;
        }
      }
    }
    return false;
  }

  bool isEmpty() {
    return flower == null;
  }

  void plant(Flower f, [int a = 0]) {
    flower = f;
    age = a;
  }

  void kill() {
    longevity = age;
  }

  String toString() {
    return x.toString() + "-" + y.toString();
  }
}

class Pollination {
  Pot p1;
  Pot p2;
  Pot p3;
  int age = 0;

  Pollination();

  Image renderOn(Image im) {

    im = p1.renderDnaOn(im);
    if (p2 != null) {
      im = p2.renderDnaOn(im);
      im = drawPath(im, p1, p2);
      if (p3 != null) {
        im = p3.renderDnaOn(im);
        im = drawPath(im, p2, p3);
        age++;
      }
    }

    return im;
  }

  Image drawPath(Image im, Pot a, Pot b) {
    im = drawStep(im, a.x - 64, a.y + 64, a.x - 74, a.y + 74);
    im = drawStep(im, a.x - 74, a.y + 74, b.x - 74, a.y + 74);
    im = drawStep(im, b.x - 74, a.y + 74, b.x - 74, b.y + 74);
    im = drawStep(im, b.x - 64, b.y + 64, b.x - 74, b.y + 74);
    return im;
  }

  Image drawStep(Image im, int ax, int ay, int bx, int by) {
    im = drawLine(im, ax, ay, bx, by, getColor(255, 255, 255));
    return drawLine(im, bx, by, ax, ay, getColor(255, 255, 255));
  }

  bool includes(Pot p) {
    return p1 == p || p2 == p || p3 == p;
  }
}
