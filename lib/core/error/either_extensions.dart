import 'package:dart_either/dart_either.dart';

extension EitherExtensions<L, R> on Either<L, R> {
  R getRight() => (this as Right<L, R>).value;
  L getLeft() => (this as Left<L, R>).value;
  
  Either<L, T> flatMap<T>(Either<L, T> Function(R r) f) {
    return fold(
      ifLeft: (l) => Left(l),
      ifRight: (r) => f(r),
    );
  }
}
