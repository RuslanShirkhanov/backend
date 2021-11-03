class Pair<A, B> {
  final A fst;
  final B snd;

  const Pair(this.fst, this.snd);

  @override
  String toString() => '($fst, $snd)';
}
