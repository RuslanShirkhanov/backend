import 'dart:convert';

import 'pair.dart';

enum ResultKind { success, failure }

String resultKindToString(ResultKind value) {
  switch (value) {
    case ResultKind.success:
      return 'success';
    case ResultKind.failure:
      return 'failure';
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

  O get asSuccess => fst!;
  E get asFailure => snd!;

  @override
  String toString() => jsonEncode(<String, dynamic>{
        'kind': resultKindToString(kind),
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
