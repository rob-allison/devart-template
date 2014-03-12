part of bloom;

class Plane {
  final int radius;
  final Map<Point, int> colours = new Map();

  Plane(this.radius);

  put(Point p, int c) {
    colours[p] = c;
  }

  int get(Point p) {
    return colours[p];
  }

  Image render(int r, int dpb) {
    int side = r * 2 * dpb;
    Image image = new Image(side, side);
    colours.forEach((p, c) {
      int x1 = (r + p.x) * dpb;
      int x2 = x1 + dpb;
      int y1 = (r + p.y) * dpb;
      int y2 = y1 + dpb;
      image = fillRect(image, x1, y1, x2, y2, c);
    });
    return image;
  }
}

typedef Point Projection(Point p);

class ProjectedPlane implements Plane {
  final Plane plane;
  final Projection projection;

  ProjectedPlane(this.plane, this.projection);

  int get radius {
    return plane.radius;
  }

  Map<Point, int> get colours {
    return plane.colours;
  }

  put(Point p, int c) {
    colours[projection(p)] = c;
  }

  int get(Point p) {
    return colours[projection(p)];
  }

  Image render(int r, int dpb) {
    return plane.render(r, dpb);
  }
}

Projection identity = (Point p) {
  return p;
};

Projection top = (Point p) {
  return p * Point.unitxnegy - Point.unity;
};

Projection topleft = (Point p) {
  return p * Point.neg - Point.unit;
};

Projection left = (Point p) {
  return p * Point.negxunity - Point.unitx;
};

class Point {
  final int x;
  final int y;
  Point(this.x, this.y);

  Point operator +(other) {
    return new Point(x + other.x, y + other.y);
  }
  
  Point operator -(other) {
    return new Point(x - other.x, y - other.y);
  }

  Point operator *(other) {
    return new Point(x * other.x, y * other.y);
  }

  String toString() {
    return x.toString() + " " + y.toString();
  }

  bool operator ==(other) {
    return other.x == x && other.y == y;
  }

  int get hashCode {
    return x + y;
  }

  static final unit = new Point(1, 1);
  static final unitx = new Point(1, 0);
  static final unity = new Point(0, 1);
  static final zero = new Point(0, 0);

  static final unitxnegy = new Point(1, -1);
  static final negxunity = new Point(-1, 1);
  static final neg = new Point(-1, -1);
}

List<Point> ring(int i) {
  List<Point> points = new List();
  int x = i;
  int y = 0;
  while (true) {
    points.add(new Point(x, y));
    if (x == 0) {
      break;
    }
    if (y == i) {
      x--;
    }
    if (x == i) {
      y++;
    }
  }
  return points;
}
