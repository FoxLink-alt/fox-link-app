import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TenantRemoteDataSource {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<String> createTenant({
    required String name,
    required String ownerId,
  }) async {
    final now = DateTime.now();
    final expiresAt = now.add(const Duration(days: 7));

    final doc = await _firestore.collection('tenants').add({
      'name': name,
      'ownerId': ownerId,
      'plan': 'trial',
      'status': 'active',
      'createdAt': FieldValue.serverTimestamp(),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'logoUrl': null,
    });

    return doc.id;
  }

  Future<void> uploadLogo({
    required String tenantId,
    required File file,
  }) async {
    final ref = _storage
        .ref()
        .child('tenants/$tenantId/logo.jpg');

    await ref.putFile(file);

    final url = await ref.getDownloadURL();

    await _firestore.collection('tenants').doc(tenantId).update({
      'logoUrl': url,
    });
  }

  Future<DocumentSnapshot> getTenant(String tenantId) {
    return _firestore.collection('tenants').doc(tenantId).get();
  }
}