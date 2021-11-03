class U<T extends num> {
  final T value;

  const U(this.value) : assert(value >= 0);

  static U<T> of<T extends num>(T value) => U<T>(value);

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(covariant U<T> that) => value == that.value;

  bool eq(T value) => this.value == value;

  bool operator <(U<T> that) => value < that.value;

  bool lt(T value) => this.value < value;

  bool operator <=(U<T> that) => value <= that.value;

  bool lte(T value) => this.value <= value;

  bool operator >(U<T> that) => value > that.value;

  bool gt(T value) => this.value > value;

  bool operator >=(U<T> that) => value >= that.value;

  bool gte(T value) => this.value >= value;

  U<T> operator +(U<T> that) => U<T>((value + that.value).abs() as T);

  U<T> operator -(U<T> that) => U<T>((value - that.value).abs() as T);

  U<T> operator *(U<T> that) => U<T>((value * that.value).abs() as T);

  U<num> operator /(U<T> that) => U<num>((value / that.value).abs());

  U<num> operator %(U<T> that) => U<num>((value % that.value).abs());

  int toInt() => value.toInt();

  double toDouble() => value.toDouble();

  @override
  String toString() => value.toString();
}
