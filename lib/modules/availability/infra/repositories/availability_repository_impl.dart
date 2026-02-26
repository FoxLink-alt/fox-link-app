import 'package:fox_link_app/core/database/tenant_firestore.dart';
import '../../domain/entities/availability.dart';
import '../../domain/repositories/availability_repository.dart';
import '../models/availability_model.dart';

class AvailabilityRepositoryImpl
    implements AvailabilityRepository {

  final TenantFirestore firestore;

  AvailabilityRepositoryImpl(this.firestore);

  @override
  Future<void> save(Availability availability) async {
    final model = AvailabilityModel(
      id: availability.id,
      professionalId: availability.professionalId,
      weekday: availability.weekday,
      startMinutes: availability.startMinutes,
      endMinutes: availability.endMinutes,
      breakStartMinutes:
      availability.breakStartMinutes,
      breakEndMinutes:
      availability.breakEndMinutes,
    );

    await firestore
        .collection('availability')
        .doc(model.id)
        .set(model.toMap());
  }

  @override
  Future<List<Availability>> getByProfessional(
      String professionalId) async {
    final snapshot = await firestore
        .collection('availability')
        .where('professionalId',
        isEqualTo: professionalId)
        .get();

    return snapshot.docs
        .map((doc) =>
        AvailabilityModel.fromMap(
            doc.data(), doc.id))
        .toList();
  }
}