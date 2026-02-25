import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfessionalAppointmentsPage extends StatelessWidget {
  const ProfessionalAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(title: const Text("Agendamentos Pendentes")),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('appointments')
            .where('professionalId', isEqualTo: 'professional_1')
            .where('status', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
                child: Text("Nenhum agendamento pendente"));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];

              return Card(
                child: ListTile(
                  title: Text("Cliente: ${doc['clientId']}"),
                  subtitle: Text(
                      "Valor: R\$ ${doc['finalPrice']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check,
                            color: Colors.green),
                        onPressed: () async {
                          await firestore
                              .collection('appointments')
                              .doc(doc.id)
                              .update({
                            'status': 'approved'
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.red),
                        onPressed: () async {
                          await firestore
                              .collection('appointments')
                              .doc(doc.id)
                              .update({
                            'status': 'rejected'
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}