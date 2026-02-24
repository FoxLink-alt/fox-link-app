import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fox_link_app/modules/auth/domain/entities/auth_user.dart';
import 'package:fox_link_app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:fox_link_app/modules/auth/infra/datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<AuthUser> signIn(String email, String password) async {
    final result = await remote.signIn(
      email: email,
      password: password,
    );

    final user = result.user!;

    return AuthUser(
      uid: user.uid,
      email: user.email!,
    );
  }

  @override
  Future<AuthUser> register(String email, String password) async {
    final result = await remote.register(
      email: email,
      password: password,
    );

    final user = result.user!;

    // Criar documento no Firestore
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'role': 'client',
      'tenantId': 'default',
      'createdAt': FieldValue.serverTimestamp(),
    });

    return AuthUser(
      uid: user.uid,
      email: user.email!,
    );
  }

  @override
  Future<void> signOut() async {
    await remote.signOut();
  }
}