import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/repositories/scheduling_repository.dart';

class SchedulingRepositoryImpl implements SchedulingRepository {
  final FirebaseFirestore firestore;

  SchedulingRepositoryImpl(this.firestore);

  @override
  Future<void> createAppointment(Appointment appointment) async {
    await firestore
        .collection('appointments')
        .doc(appointment.id)
        .set({
      'tenantId': appointment.tenantId,
      'serviceId': appointment.serviceId,
      'clientId': appointment.clientId,
      'professionalId': appointment.professionalId,
      'scheduledStart': appointment.scheduledStart,
      'scheduledEnd': appointment.scheduledEnd,
      'finalPrice': appointment.finalPrice,
      'finalDuration': appointment.finalDuration,
      'status': appointment.status.name,
      'createdAt': appointment.createdAt,
    });
  }

  @override
  Future<List<Appointment>> getApprovedAppointments({
    required String professionalId,
    required DateTime date,
  }) async {
    final startOfDay =
    DateTime(date.year, date.month, date.day);
    final endOfDay =
    DateTime(date.year, date.month, date.day, 23, 59, 59);

    final snapshot = await firestore
        .collection('appointments')
        .where('professionalId', isEqualTo: professionalId)
        .where('status', isEqualTo: 'approved')
        .where('scheduledStart', isGreaterThanOrEqualTo: startOfDay)
        .where('scheduledStart', isLessThanOrEqualTo: endOfDay)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Appointment(
        id: doc.id,
        tenantId: data['tenantId'],
        serviceId: data['serviceId'],
        clientId: data['clientId'],
        professionalId: data['professionalId'],
        scheduledStart:
        (data['scheduledStart'] as Timestamp).toDate(),
        scheduledEnd:
        (data['scheduledEnd'] as Timestamp).toDate(),
        finalPrice: (data['finalPrice'] as num).toDouble(),
        finalDuration: data['finalDuration'],
        status: AppointmentStatus.values.firstWhere(
              (e) => e.name == data['status'],
        ),
        createdAt:
        (data['createdAt'] as Timestamp).toDate(),
      );
    }).toList();
  }

  @override
  Future<void> updateAppointment(Appointment appointment) async {
    await firestore
        .collection('appointments')
        .doc(appointment.id)
        .update({
      'scheduledStart': appointment.scheduledStart,
      'scheduledEnd': appointment.scheduledEnd,
      'finalPrice': appointment.finalPrice,
      'finalDuration': appointment.finalDuration,
      'status': appointment.status.name,
    });
  }
}