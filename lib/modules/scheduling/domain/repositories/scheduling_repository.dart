import '../entities/appointment.dart';

abstract class SchedulingRepository {
  Future<void> createAppointment(Appointment appointment);

  Future<List<Appointment>> getApprovedAppointments({
    required String professionalId,
    required DateTime date,
  });

  Future<void> updateAppointment(Appointment appointment);
}