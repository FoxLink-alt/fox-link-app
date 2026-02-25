import '../entities/availability.dart';

abstract class AvailabilityRepository {
  Future<List<Availability>> getByProfessional({
    required String tenantId,
    required String professionalId,
  });
}