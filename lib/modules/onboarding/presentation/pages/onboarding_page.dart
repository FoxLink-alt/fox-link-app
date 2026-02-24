import 'package:flutter/material.dart';
import 'package:fox_link_app/injection/injection.dart';
import 'package:fox_link_app/core/session/tenant_session.dart';
import 'package:fox_link_app/modules/users/infra/datasources/user_remote_datasource.dart';
import 'package:fox_link_app/modules/tenant/infra/datasources/tenant_remote_datasource.dart';
import 'package:fox_link_app/modules/dashboard/presentation/pages/admin_dashboard.dart';

class OnboardingPage extends StatefulWidget {
  final String uid;
  final String email;

  const OnboardingPage({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phone = TextEditingController();
  final _salonName = TextEditingController();

  final _userRemote = getIt<UserRemoteDataSource>();
  final _tenantRemote = getIt<TenantRemoteDataSource>();
  final _session = getIt<TenantSession>();

  bool isLoading = false;

  Future<void> _finishOnboarding() async {
    setState(() => isLoading = true);

    final tenantId = await _tenantRemote.createTenant(
      name: _salonName.text.trim(),
      ownerId: widget.uid,
    );

    await _userRemote.createUser(
      uid: widget.uid,
      email: widget.email,
      role: 'admin',
      tenantId: tenantId,
    );

    await _userRemote.updateUser(
      uid: widget.uid,
      data: {
        'firstName': _firstName.text.trim(),
        'lastName': _lastName.text.trim(),
        'phone': _phone.text.trim(),
      },
    );

    _session.setSession(
      tenantId: tenantId,
      role: 'admin',
      uid: widget.uid,
      email: widget.email,
    );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AdminDashboard()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configurar seu Salão")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            TextField(
              controller: _firstName,
              decoration: const InputDecoration(labelText: "Nome"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _lastName,
              decoration: const InputDecoration(labelText: "Sobrenome"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phone,
              decoration: const InputDecoration(labelText: "Telefone"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _salonName,
              decoration: const InputDecoration(labelText: "Nome do Salão"),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: isLoading ? null : _finishOnboarding,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Finalizar Cadastro"),
            )
          ],
        ),
      ),
    );
  }
}