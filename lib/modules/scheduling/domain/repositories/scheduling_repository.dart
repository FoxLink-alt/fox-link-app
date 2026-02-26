import '../entities/appointment.dart';

abstract class SchedulingRepository {

  Future<void> create(Appointment appointment);

  Future<void> updateStatus(
      String appointmentId,
      AppointmentStatus status,
      );

  Future<List<Appointment>> getApprovedByProfessionalAndDate({
    required String professionalId,
    required DateTime date,
  });

  // 🔥 NOVOS MÉTODOS PARA REAGENDAMENTO

  Future<void> requestReschedule({
    required String appointmentId,
    required DateTime proposedStart,
    required DateTime proposedEnd,
  });

  Future<void> confirmReschedule({
    required String appointmentId,
    required DateTime newStart,
    required DateTime newEnd,
  });

  // 🔥 NOVO MÉTODO
  Future<List<Appointment>> getPendingByProfessional(
      String professionalId,
      );
}