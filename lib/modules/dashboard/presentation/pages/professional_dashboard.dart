import 'package:flutter/material.dart';

class ProfessionalDashboard extends StatelessWidget {
  const ProfessionalDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profissional")),
      body: const Center(
        child: Text(
          "Dashboard Profissional 💼",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}