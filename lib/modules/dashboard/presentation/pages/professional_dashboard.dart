import 'package:flutter/material.dart';
import 'package:fox_link_app/modules/scheduling/presentation/pages/professional_appointments_page.dart';

class ProfessionalDashboard extends StatelessWidget {
  const ProfessionalDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(title: const Text("Profissional")),
      body: Padding(
        padding:
        const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(
                    Icons.calendar_month),
                title: const Text(
                    "Meus Agendamentos"),
                trailing:
                const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      ProfessionalAppointmentsPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}