part of bloom;

class CircularList<E> extends ListBase<E> {
  final List<E> list;
  final int offset;
  final bool positive;

  CircularList(this.list, this.offset, [this.positive = true]);

  CircularList.project(List<E> wlist, CircularList<E> clist)
      : list = wlist,
        offset = clist.offset * wlist.length ~/ clist.length,
        positive = clist.positive;

  void set length(int l) {
    list.length = l;
  }

  int get length => list.length;

  E operator [](int i) => list[_index(i)];

  void operator []=(int i, E value) {
    list[_index(i)] = value;
  }

  _index(int i) {
    return positive ? (i + offset) % length : length - ((i + offset) % length) - 1;
  }
}
