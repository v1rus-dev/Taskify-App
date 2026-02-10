import 'package:equatable/equatable.dart';

class PagedResultEntity<T> extends Equatable {
  const PagedResultEntity({required this.items, this.nextCursor});

  final List<T> items;
  final String? nextCursor;

  @override
  List<Object?> get props => [items, nextCursor];
}
