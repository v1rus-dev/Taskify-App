import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';

typedef ApiResult<T> = Either<Failure, T>;
