import '../entities/appointment.dart';
import '../repositories/scheduling_repository.dart';
import '../services/schedule_validator.dart';

class CreateAppointmentUseCase {
  final SchedulingRepository repository;

  CreateAppointmentUseCase(this.repository);

  Future<void> call(Appointment appointment) async {
    // Buscar agendamentos aprovados do profissional no dia
    final approvedAppointments =
    await repository.getApprovedAppointments(
      professionalId: appointment.professionalId,
      date: appointment.scheduledStart,
    );

    // Validar conflito
    ScheduleValidator.validateConflict(
      newAppointment: appointment,
      approvedAppointments: approvedAppointments,
    );

    // Criar agendamento
    await repository.createAppointment(appointment);
  }
}