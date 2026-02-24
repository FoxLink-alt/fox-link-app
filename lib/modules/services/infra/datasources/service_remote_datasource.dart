import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fox_link_app/core/config/plan_config.dart';
import 'package:fox_link_app/injection/injection.dart';
import 'package:fox_link_app/core/session/tenant_session.dart';

class ServiceRemoteDataSource {
  final _firestore = FirebaseFirestore.instance;
  final _session = getIt<TenantSession>();

  Future<int> getCurrentCount() async {
    final snapshot = await _firestore
        .collection('services')
        .where('tenantId', isEqualTo: _session.tenantId)
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

  Future<void> createService(String name, double price) async {
    final plan = await getCurrentPlan();
    final count = await getCurrentCount();

    if (count >= PlanConfig.maxServices(plan)) {
      throw Exception("Limite de serviços do plano atingido.");
    }

    await _firestore.collection('services').add({
      'tenantId': _session.tenantId,
      'name': name,
      'price': price,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteService(String id) async {
    await _firestore.collection('services').doc(id).delete();
  }

  Stream<QuerySnapshot> streamServices() {
    return _firestore
        .collection('services')
        .where('tenantId', isEqualTo: _session.tenantId)
        .snapshots();
  }
}