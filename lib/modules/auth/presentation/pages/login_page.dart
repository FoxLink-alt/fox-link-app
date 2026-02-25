import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fox_link_app/injection/injection.dart';
import 'package:fox_link_app/core/session/tenant_session.dart';
import 'package:fox_link_app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:fox_link_app/modules/dashboard/presentation/pages/client_dashboard.dart';
import 'package:fox_link_app/modules/dashboard/presentation/pages/professional_dashboard.dart';
import 'package:fox_link_app/modules/dashboard/presentation/pages/admin_dashboard.dart';
import 'package:fox_link_app/modules/master/presentation/pages/master_dashboard.dart';
import 'package:fox_link_app/modules/onboarding/presentation/pages/onboarding_page.dart';
import 'package:fox_link_app/modules/users/infra/datasources/user_remote_datasource.dart';
import 'package:fox_link_app/modules/tenant/infra/datasources/tenant_remote_datasource.dart';
import 'package:fox_link_app/modules/subscription/presentation/pages/trial_expired_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _authRepository = getIt<AuthRepository>();
  final _userRemote = getIt<UserRemoteDataSource>();
  final _tenantRemote = getIt<TenantRemoteDataSource>();
  final _tenantSession = getIt<TenantSession>();

  bool isLogin = true;
  bool isLoading = false;

  Future<void> _submit() async {
    setState(() => isLoading = true);

    try {
      if (isLogin) {
        // 🔐 LOGIN

        final user = await _authRepository.signIn(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        final userData = await _userRemote.getUser(user.uid);
        final role = userData['role'];

        // 👑 MASTER não pertence a tenant
        if (role == 'master') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MasterDashboard()),
          );
          return;
        }

        // 🔍 Buscar tenant
        final tenantData =
        await _tenantRemote.getTenant(userData['tenantId']);

        final status = tenantData['status'];
        final expiresAt =
        (tenantData['expiresAt'] as Timestamp).toDate();

        if (status != 'active') {
          throw Exception("Seu salão está suspenso.");
        }

        if (DateTime.now().isAfter(expiresAt)) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const TrialExpiredPage(),
            ),
          );
          return;
        }

        // 💾 Salvar sessão
        _tenantSession.setSession(
          tenantId: userData['tenantId'],
          role: role,
          uid: user.uid,
          email: user.email ?? '',
        );

        _redirectByRole(role);
      } else {
        // 🏢 REGISTRO - Apenas cria conta
        final user = await _authRepository.register(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => OnboardingPage(
              uid: user.uid,
              email: user.email ?? '',
            ),
          ),
        );

        return;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    setState(() => isLoading = false);
  }

  void _redirectByRole(String role) {
    if (role == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminDashboard()),
      );
    } else if (role == 'professional') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfessionalDashboard()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) =>  ClientDashboard()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Fox Link 🦊",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Senha"),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: isLoading ? null : _submit,
                child: isLoading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : Text(isLogin ? "Entrar" : "Criar Conta"),
              ),
              TextButton(
                onPressed: () {
                  setState(() => isLogin = !isLogin);
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