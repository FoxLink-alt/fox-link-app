import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fox_link_app/injection/injection.dart';
import 'package:fox_link_app/core/session/tenant_session.dart';
import 'package:fox_link_app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:fox_link_app/modules/dashboard/presentation/pages/client_dashboard.dart';
import 'package:fox_link_app/modules/dashboard/presentation/pages/professional_dashboard.dart';
import 'package:fox_link_app/modules/dashboard/presentation/pages/admin_dashboard.dart';
import 'package:fox_link_app/modules/master/presentation/pages/master_dashboard.dart';
import 'package:fox_link_app/modules/subscription/presentation/pages/trial_expired_page.dart';
import 'package:fox_link_app/modules/users/infra/datasources/user_remote_datasource.dart';
import 'package:fox_link_app/modules/tenant/infra/datasources/tenant_remote_datasource.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() =>
      _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController =
  TextEditingController();
  final _passwordController =
  TextEditingController();

  final _authRepository =
  getIt<AuthRepository>();
  final _userRemote =
  getIt<UserRemoteDataSource>();
  final _tenantRemote =
  getIt<TenantRemoteDataSource>();
  final _tenantSession =
  getIt<TenantSession>();

  bool isLogin = true;
  bool isLoading = false;

  // ============================================================
  // 🔥 MÉTODO PRINCIPAL (LOGIN + REGISTRO)
  // ============================================================
  Future<void> _submit() async {
    setState(() => isLoading = true);

    try {
      if (isLogin) {
        // ============================================================
        // 🔐 LOGIN
        // ============================================================

        final user =
        await _authRepository.signIn(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        // 🔍 Busca dados do usuário
        final userData =
        await _userRemote.getUser(user.uid);

        final role = userData['role'];

        // 👑 MASTER (não pertence a tenant)
        if (role == 'master') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
              const MasterDashboard(),
            ),
          );
          return;
        }

        // 🔎 Busca dados do tenant
        final tenantData =
        await _tenantRemote.getTenant(
          userData['tenantId'],
        );

        final status = tenantData['status'];
        final expiresAt =
        (tenantData['expiresAt']
        as Timestamp)
            .toDate();

        // 🚫 Salão suspenso
        if (status != 'active') {
          throw Exception(
              "Seu salão está suspenso.");
        }

        // ⏰ Plano expirado
        if (DateTime.now()
            .isAfter(expiresAt)) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
              const TrialExpiredPage(),
            ),
          );
          return;
        }

        // 💾 Salva sessão
        _tenantSession.setSession(
          tenantId:
          userData['tenantId'],
          role: role,
          uid: user.uid,
          email: user.email ?? '',
        );

        _redirectByRole(role);

      } else {
        // ============================================================
        // 🏢 REGISTRO COM VALIDAÇÃO DE CONVITE
        // ============================================================

        final email =
        _emailController.text.trim();
        final password =
        _passwordController.text.trim();

        // 🔥 Verifica se existe convite
        final pendingDoc =
        await FirebaseFirestore
            .instance
            .collection(
            'users_pending')
            .doc(email)
            .get();

        if (!pendingDoc.exists) {
          throw Exception(
              "Você não possui convite para este salão.");
        }

        final pendingData =
        pendingDoc.data()!;

        final tenantId =
        pendingData['tenantId'];
        final role =
        pendingData['role'];
        final name =
        pendingData['name'];

        // 🔐 Cria conta no Auth
        final user =
        await _authRepository
            .register(
          email,
          password,
        );

        // 🗂 Cria usuário definitivo
        await FirebaseFirestore
            .instance
            .collection('users')
            .doc(user.uid)
            .set({
          'tenantId': tenantId,
          'role': role,
          'name': name,
          'email': email,
          'createdAt':
          FieldValue
              .serverTimestamp(),
        });

        // 🗑 Remove convite
        await FirebaseFirestore
            .instance
            .collection(
            'users_pending')
            .doc(email)
            .delete();

        // 💾 Salva sessão
        _tenantSession.setSession(
          tenantId: tenantId,
          role: role,
          uid: user.uid,
          email: email,
        );

        _redirectByRole(role);
      }

    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    setState(() => isLoading = false);
  }

  // ============================================================
  // 🔄 REDIRECIONAMENTO POR ROLE
  // ============================================================
  void _redirectByRole(String role) {
    if (role == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) =>
            const AdminDashboard()),
      );
    } else if (role == 'professional') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) =>
            const ProfessionalDashboard()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) =>
                ClientDashboard()),
      );
    }
  }

  // ============================================================
  // 🎨 UI
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding:
          const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              const Text(
                "Fox Link 🦊",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),

              TextField(
                controller:
                _emailController,
                decoration:
                const InputDecoration(
                    labelText:
                    "Email"),
              ),
              const SizedBox(height: 20),

              TextField(
                controller:
                _passwordController,
                obscureText: true,
                decoration:
                const InputDecoration(
                    labelText:
                    "Senha"),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed:
                isLoading
                    ? null
                    : _submit,
                child: isLoading
                    ? const CircularProgressIndicator(
                  color:
                  Colors.white,
                )
                    : Text(isLogin
                    ? "Entrar"
                    : "Criar Conta"),
              ),

              TextButton(
                onPressed: () {
                  setState(() =>
                  isLogin =
                  !isLogin);
                },
                child: Text(
                  isLogin
                      ? "Não tem conta? Criar agora"
                      : "Já tem conta? Fazer login",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}