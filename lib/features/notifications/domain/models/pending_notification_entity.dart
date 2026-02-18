import 'package:equatable/equatable.dart';

class PendingNotificationEntity extends Equatable {
  const PendingNotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;

  @override
  List<Object?> get props => [id, title, body, payload];
}
