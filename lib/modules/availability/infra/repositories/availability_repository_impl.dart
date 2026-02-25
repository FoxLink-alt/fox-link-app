import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/availability.dart';
import '../../domain/repositories/availability_repository.dart';

class AvailabilityRepositoryImpl implements AvailabilityRepository {
  final FirebaseFirestore firestore;

  AvailabilityRepositoryImpl(this.firestore);

  @override
  Future<List<Availability>> getByProfessional({
    required String tenantId,
    required String professionalId,
  }) async {
    final snapshot = await firestore
        .collection('availability')
        .where('tenantId', isEqualTo: tenantId)
        .where('professionalId', isEqualTo: professionalId)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Availability(
        id: doc.id,
        tenantId: data['tenantId'],
        professionalId: data['professionalId'],
        weekday: data['weekday'],
        startHour: data['startHour'],
        endHour: data['endHour'],
        breakStartHour: data['breakStartHour'],
        breakEndHour: data['breakEndHour'],
      );
    }).toList();
  }
}