import 'package:equatable/equatable.dart';

enum AppointmentStatus {
  pending,
  approved,
  rejected,
  cancelled,
  completed,
}

class Appointment extends Equatable {
  final String id;
  final String tenantId;
  final String serviceId;
  final String clientId;
  final String professionalId;

  final DateTime scheduledStart;
  final DateTime scheduledEnd;

  final double finalPrice;
  final int finalDuration;

  final AppointmentStatus status;
  final DateTime createdAt;

  const Appointment({
    required this.id,
    required this.tenantId,
    required this.serviceId,
    required this.clientId,
    required this.professionalId,
    required this.scheduledStart,
    required this.scheduledEnd,
    required this.finalPrice,
    required this.finalDuration,
    required this.status,
    required this.createdAt,
  });

  bool get isPending => status == AppointmentStatus.pending;
  bool get isApproved => status == AppointmentStatus.approved;

  Appointment approve({
    required double price,
    required int duration,
  }) {
    return Appointment(
      id: id,
      tenantId: tenantId,
      serviceId: serviceId,
      clientId: clientId,
      professionalId: professionalId,
      scheduledStart: scheduledStart,
      scheduledEnd: scheduledStart.add(Duration(minutes: duration)),
      finalPrice: price,
      finalDuration: duration,
      status: AppointmentStatus.approved,
      createdAt: createdAt,
    );
  }

  Appointment reject() {
    return copyWith(status: AppointmentStatus.rejected);
  }

  Appointment copyWith({
    AppointmentStatus? status,
  }) {
    return Appointment(
      id: id,
      tenantId: tenantId,
      serviceId: serviceId,
      clientId: clientId,
      professionalId: professionalId,
      scheduledStart: scheduledStart,
      scheduledEnd: scheduledEnd,
      finalPrice: finalPrice,
      finalDuration: finalDuration,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    tenantId,
    serviceId,
    clientId,
    professionalId,
    scheduledStart,
    scheduledEnd,
    finalPrice,
    finalDuration,
    status,
    createdAt,
  ];
}