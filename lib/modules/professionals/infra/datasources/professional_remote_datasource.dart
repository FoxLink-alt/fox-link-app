import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fox_link_app/core/config/plan_config.dart';
import 'package:fox_link_app/injection/injection.dart';
import 'package:fox_link_app/core/session/tenant_session.dart';

class ProfessionalRemoteDataSource {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final TenantSession _session =
  getIt<TenantSession>();

  Future<int> getCurrentCount() async {
    final snapshot = await _firestore
        .collection('professionals')
        .where('tenantId',
        isEqualTo: _session.tenantId)
        .get();

    return snapshot.docs.length;
  }

  Future<String> getCurrentPlan() async {
    final tenantDoc = await _firestore
        .collection('tenants')
        .doc(_session.tenantId)
        .get();

    return tenantDoc['plan'];
  }

  Future<void> createProfessional({
    required String name,
    required String email,
  }) async {

    final plan = await getCurrentPlan();
    final count = await getCurrentCount();

    if (count >=
        PlanConfig.maxProfessionals(plan)) {
      throw Exception(
          "Limite de profissionais do plano atingido.");
    }

    // 🔥 Verifica se já existe convite
    final pendingDoc = await _firestore
        .collection('users_pending')
        .doc(email)
        .get();

    if (pendingDoc.exists) {
      throw Exception(
          "Já existe um convite para este email.");
    }

    // 🔥 Salva profissional
    await _firestore
        .collection('professionals')
        .add({
      'tenantId': _session.tenantId,
      'name': name,
      'email': email,
      'createdAt':
      FieldValue.serverTimestamp(),
    });

    // 🔥 Cria convite
    await _firestore
        .collection('users_pending')
        .doc(email)
        .set({
      'tenantId': _session.tenantId,
      'role': 'professional',
      'name': name,
      'createdAt':
      FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteProfessional(
      String id) async {
    await _firestore
        .collection('professionals')
        .doc(id)
        .delete();
  }

  Stream<QuerySnapshot>
  streamProfessionals() {
    return _firestore
        .collection('professionals')
        .where('tenantId',
        isEqualTo: _session.tenantId)
        .snapshots();
  }
}