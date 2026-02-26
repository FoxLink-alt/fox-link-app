import '../entities/availability.dart';

abstract class AvailabilityRepository {
  Future<void> save(Availability availability);

  Future<List<Availability>> getByProfessional(
      String professionalId,
      );
}