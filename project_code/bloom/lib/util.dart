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

class ByteList extends ListBase<int>{
  
  final ByteData bytes;

  ByteList(this.bytes);
  
  ByteList.ofLength(int length): bytes = new ByteData(length);

  int operator [](int i) => bytes.getUint8(i);

  void operator []=(int i, int value) {
    bytes.setUint8(i, value);
  }
  
  int get length {
    return bytes.lengthInBytes;
  }
  
  void set length(int length) {
    throw "length cannot be set";
  }
}

class SubList<E> extends ListBase<E>{
  final List list;
  final int offset;
  final int length;
  
  SubList(this.list,this.offset,this.length);
  
  E operator [](int i) => list[offset + i];
  
  void operator []=(int i, E value) {
    list[offset+i]=value;
  }
}

class BitList extends ListBase<bool> {

  static String clean( String str ) {
    Pattern pattern = new RegExp(" ");
    return str.replaceAll(pattern, "");
  }
  
  final ByteList bytes;

  BitList(this.bytes);

  BitList.fromString(String str): bytes = new ByteList.ofLength(str.length ~/ 8)
      {
    for (int i = 0; i < str.length; i++) {
      this[i] = str[i] == "1"[0];
    }
  }
  
  BitList.ofLength(int length): bytes = new ByteList.ofLength(length ~/ 8);

  BitList.ofLengthWithOnes(int length): bytes = new ByteList.ofLength(length ~/ 8) {
    for ( int i = 0; i < length; i++ ) {
      this[i] = true;
    }
  }
  
  bool operator [](int i) => (bytes[i ~/ 8] & (1 << (i % 8))) != 0;

  void operator []=(int i, bool value) {
    bytes[i ~/ 8] = value ? bytes[i ~/ 8] | (1 << (i % 8)) : bytes[i ~/
        8] & ~(1 << (i % 8));
  }

  int get length => bytes.length * 8;

  void set length(int length) => throw "unmodifiable length";

  Iterator<bool> get modifyingIterator => new ModifyingIterator(this);

  BitList copy() {
    BitList cpy = new BitList.ofLength(length);
    for (int i = 0; i < length; i++) {
      cpy[i] = this[i];
    }
    return cpy;
  }

  String toString() {
    StringBuffer sb = new StringBuffer( );
    this.forEach((b) {
      sb.write( b ? "1" : "0" );
    });
    return sb.toString();
  }
  
  BitList subList( int offset, int length ) {
    BitList result = new BitList.ofLength(length);
    for ( int i = 0; i < length; i++ ) {
      result[i] = this[offset+i];
    }
    return result;
  }
}

class ModifyingIterator<E> extends Iterator<E> {
  final Iterator iter;
  final List<E> list;
  int i = -1;

  ModifyingIterator(List list)
      : this.list = list,
        iter = list.iterator;

  bool moveNext() {
    if (iter.moveNext()) {
      i++;
      return true;
    } else {
      return false;
    }
  }

  E get current => iter.current;

  void set current(E e) {
    list[i] = e;
  }
}
