part of bloom;

class CentreGrowth implements Iterator<Plane> {
  final Iterator centres;
  Plane current;

  CentreGrowth(this.centres);

  bool moveNext() {
    if (centres.moveNext()) {
      current = buildPlane(centres.current, current);
      return true;
    } else {
      return false;
    }
  }

  Plane buildPlane(int centre, Plane last) {
    if (current != null) {
      Plane next = new Plane(last.radius + 1);
      growp(centre, last, next, identity);
      growp(centre, last, next, left);
      growp(centre, last, next, top);
      growp(centre, last, next, topleft);
      return next;
    } else {
      Plane start = new Plane(1);
      new ProjectedPlane(start, identity)..put(Point.zero, centres.current);
      new ProjectedPlane(start, left)..put(Point.zero, centres.current);
      new ProjectedPlane(start, top)..put(Point.zero, centres.current);
      new ProjectedPlane(start, topleft)..put(Point.zero, centres.current);
      return start;
    }
  }

  growp(int centre, Plane last, Plane next, Projection proj) {
    grow(centre, new ProjectedPlane(last, proj), new ProjectedPlane(next, proj)
        );
  }

  grow(int centre, Plane last, Plane next) {
    next.put(Point.zero, centre);
    for (int i = 0; i < last.radius; i++) {

      var points = ring(i);
      for (Point p in points) {
        int c = last.get(p);
        next.put(p + Point.unit, c);
      }

      Point top = new Point(0, i);
      next.put(top + Point.unity, last.get(top));

      Point right = new Point(i, 0);
      next.put(right + Point.unitx, last.get(right));
    }
  }
}
