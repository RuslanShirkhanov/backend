import 'dart:convert';

import 'pair.dart';

enum ResultKind { success, failure }

extension ResultKindShow on ResultKind {
  String get show {
    switch (this) {
      case ResultKind.success:
        return 'success';
      case ResultKind.failure:
        return 'failure';
      default:
        throw TypeError();
    }
  }
}

class Result<O, E> extends Pair<O?, E?> {
  final ResultKind kind;

  const Result.success(O value)
      : kind = ResultKind.success,
        super(value, null);
  const Result.failure(E value)
      : kind = ResultKind.failure,
        super(null, value);

  bool get isSuccess => fst != null && snd == null;
  bool get isFailure => fst == null && snd != null;
}

extension ResultShow on Result {
  String get show => jsonEncode(<String, dynamic>{
        'kind': kind.show,
        'value': fst,
        'error': snd,
      });
}

extension ToOk<O, E> on O {
  Result<O, E> get success => Result.success(this);
}

extension ToErr<O, E> on E {
  Result<O, E> get failure => Result.failure(this);
}
