import 'package:equatable/equatable.dart';

class Availability extends Equatable {
  final String id;
  final String tenantId;
  final String professionalId;

  final int weekday; // 1 = Monday ... 7 = Sunday
  final int startHour;
  final int endHour;

  final int? breakStartHour;
  final int? breakEndHour;

  const Availability({
    required this.id,
    required this.tenantId,
    required this.professionalId,
    required this.weekday,
    required this.startHour,
    required this.endHour,
    this.breakStartHour,
    this.breakEndHour,
  });

  @override
  List<Object?> get props => [
    id,
    tenantId,
    professionalId,
    weekday,
    startHour,
    endHour,
    breakStartHour,
    breakEndHour,
  ];
}