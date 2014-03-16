part of bloom;

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
    return "(" + x.toString() + "," + y.toString() + ")";
  }

  bool operator ==(other) {
    return other.x == x && other.y == y;
  }

  int get hashCode {
    return x + y;
  }
}

List<Point> generateRingPoints(int i) {
  
  List<Point> points = new List();
  int x = i - 1;
  int y = -i;
  int side = 0;
  while (true) {

    points.add(new Point(x, y));

    if (x == i - 1 && y == i - 1) {
      side = 1;
    }

    if (x == -i && y == i - 1) {
      side = 2;
    }

    if (x == -i && y == -i) {
      side = 3;
    }

    if (x == i - 2 && y == -i) {
      break;
    }

    switch (side) {
      case 0:
        y++;
        break;
      case 1:
        x--;
        break;
      case 2:
        y--;
        break;
      case 3:
        x++;
        break;
    }
  }
  
  return points;
}
