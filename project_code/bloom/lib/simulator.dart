part of bloom;

class Simulator {

  final Random rng = new Random();
  final List<Pot> pots = new List();
  final int xdim;
  final int ydim;
  final int gap;
  final List<Route> routes = new List();

  Simulator(this.xdim, this.ydim, this.gap) {
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
      pots[rng.nextInt(pots.length)].plant(rng, [rdna.build(), rdna.build(),
          rdna.build()], rng.nextInt(200));
    }
  }


  Image render() {
    int xside = (xdim * 128) + ((xdim + 1) * gap);
    int yside = (ydim * 128) + ((ydim + 1) * gap);
    Image image = new Image(xside, yside);
    fill(image, getColor(20, 20, 20));
    pots.forEach((pot) {
      image = pot.renderOn(image,routesInclude(pot));
    });

    routes.removeWhere((r) => r.age > 40);
    routes.forEach((r) {
      image = r.renderOn(image);
    });

    return image;
  }


  void pollinate() {

    List<Pot> mature = new List();
    pots.forEach((p) {
      if (p.mature()) {
        mature.add(p);
      }
    });

    List<Pot> empty = new List();
    pots.forEach((p) {
      if (p.empty()) {
        empty.add(p);
      }
    });

    if (mature.length >= 2 && empty.length >= 1) {
      int i1 = rng.nextInt(mature.length);
      int i2 = i1;
      while (i1 == i2) {
        i2 = rng.nextInt(mature.length);
      }

      Pot p1 = mature[i1];
      Pot p2 = mature[i2];
      Pot p3 = empty[rng.nextInt(empty.length)];

      List<Dna> dna1 = p1.collect();
      List<Dna> dna2 = p2.collect();
      List<Dna> dna = breed(rng, dna1, dna2);
      p3.plant(rng, dna);
      routes.add(new Route(p1, p2, p3));
    }
  }

  bool routesInclude(Pot p) {
    for ( Route r in routes ) {
      if ( r.includes(p) ) {
        return true;
      }
    }
    return false;
  }
}

class Pot {

  static final int longevity = 900;
  final int x;
  final int y;
  Flower flower;
  int age;

  Pot(this.x, this.y);

  Image renderOn(Image image, bool routed) {
    if (flower != null) {
      if (flower.radius < 64) {
        flower = flower.grow();
        age++;
        image = fillRect(image, x - 64, y - 64, x + 63, y + 63, getColor(0, 0, 0
            ));
        image = flower.renderOn(image, x, y, 1);
        if (routed) image = renderDnaOn(image);
        return image;
      } else if (age < longevity) {
        age++;
        image = flower.renderOn(image, x, y, 1);
        if (routed) image = renderDnaOn(image);
        return image;
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

  bool mature() {
    if (flower != null) {
      if (flower.radius == 64) {
        if (age < longevity - 50) {
          return true;
        }
      }
    }
    return false;
  }

  bool empty() {
    return flower == null;
  }

  void plant(Random rng, List<Dna> dna, [a = 0]) {
    flower = new Flower.start(rng, dna);
    age = a;
  }

  String toString() {
    return x.toString() + "-" + y.toString();
  }
}

class Route {
  final Pot p1;
  final Pot p2;
  final Pot p3;
  int age = 0;

  Route(this.p1, this.p2, this.p3);

  Image renderOn(Image im) {
    age++;
    im = drawPath(im, p1, p2);
    im = drawPath(im, p2, p3);
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
