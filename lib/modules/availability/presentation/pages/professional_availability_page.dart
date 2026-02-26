import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/availability_controller.dart';

class ProfessionalAvailabilityPage extends StatelessWidget {
  final String professionalId;

  const ProfessionalAvailabilityPage({
    super.key,
    required this.professionalId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
      AvailabilityController()
        ..load(professionalId),
      child: const _AvailabilityView(),
    );
  }
}

class _AvailabilityView extends StatelessWidget {
  const _AvailabilityView();

  @override
  Widget build(BuildContext context) {
    final controller =
    context.watch<AvailabilityController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Minha Disponibilidade"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _openForm(context),
        child: const Icon(Icons.add),
      ),
      body: controller.isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount:
        controller.availabilityList.length,
        itemBuilder: (_, index) {
          final item =
          controller.availabilityList[index];

          return ListTile(
            title: Text(
                "Dia ${item.weekday}"),
            subtitle: Text(
                "${item.startMinutes} - ${item.endMinutes}"),
          );
        },
      ),
    );
  }

  void _openForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) =>
      const _AvailabilityFormDialog(),
    );
  }
}

class _AvailabilityFormDialog
    extends StatefulWidget {
  const _AvailabilityFormDialog();

  @override
  State<_AvailabilityFormDialog> createState() =>
      _AvailabilityFormDialogState();
}

class _AvailabilityFormDialogState
    extends State<_AvailabilityFormDialog> {

  final _weekday =
  TextEditingController();
  final _start =
  TextEditingController();
  final _end =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller =
    context.read<AvailabilityController>();

    return AlertDialog(
      title:
      const Text("Nova Disponibilidade"),
      content: Column(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          TextField(
            controller: _weekday,
            decoration:
            const InputDecoration(
                labelText: "Dia (1-7)"),
          ),
          TextField(
            controller: _start,
            decoration:
            const InputDecoration(
                labelText:
                "Início (min)"),
          ),
          TextField(
            controller: _end,
            decoration:
            const InputDecoration(
                labelText:
                "Fim (min)"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () async {
            await controller.save(
              professionalId:
              controller.availabilityList
                  .isNotEmpty
                  ? controller
                  .availabilityList
                  .first
                  .professionalId
                  : "",
              weekday:
              int.parse(_weekday.text),
              startMinutes:
              int.parse(_start.text),
              endMinutes:
              int.parse(_end.text),
            );

            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          child: const Text("Salvar"),
        ),
      ],
    );
  }
}