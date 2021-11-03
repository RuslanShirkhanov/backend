extension Compose<A, B> on B Function(A) {
  C Function(A) then<C>(C Function(B) g) => (A x) => g(this(x));
}
