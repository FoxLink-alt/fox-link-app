import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';
import 'package:fox_link_app/core/session/tenant_session.dart';

import '../../../availability/domain/repositories/availability_repository.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/usecases/create_appointment_usecase.dart';
import '../../domain/services/slot_generator.dart';

class CreateAppointmentPage extends StatefulWidget {
  const CreateAppointmentPage({super.key});

  @override
  State<CreateAppointmentPage> createState() =>
      _CreateAppointmentPageState();
}

class _CreateAppointmentPageState
    extends State<CreateAppointmentPage> {
  final _useCase = GetIt.I<CreateAppointmentUseCase>();
  final _availabilityRepo = GetIt.I<AvailabilityRepository>();
  final _tenantSession = GetIt.I<TenantSession>();

  DateTime? selectedDate;
  List<DateTime> availableSlots = [];
  DateTime? selectedSlot;

  bool loading = false;

  Future<void> _loadSlots() async {
    if (selectedDate == null) return;

    final availabilityList =
    await _availabilityRepo.getByProfessional(
      tenantId: _tenantSession.tenantId!,
      professionalId: _tenantSession.uid!, // 🔥 profissional real depois ajustamos
    );

    final weekday = selectedDate!.weekday;

    final availability = availabilityList.firstWhere(
          (a) => a.weekday == weekday,
      orElse: () => throw Exception("Profissional não atende nesse dia"),
    );

    final slots = SlotGenerator.generateSlots(
      date: selectedDate!,
      durationMinutes: 60,
      availability: availability,
    );

    setState(() {
      availableSlots = slots;
    });
  }

  Future<void> _createAppointment() async {
    if (selectedSlot == null) return;

    setState(() => loading = true);

    final appointment = Appointment(
      id: const Uuid().v4(),
      tenantId: _tenantSession.tenantId!,
      serviceId: "service_1", // depois conectamos ao service real
      clientId: _tenantSession.uid!,
      professionalId: _tenantSession.uid!, // vamos melhorar com seleção de profissional
      scheduledStart: selectedSlot!,
      scheduledEnd:
      selectedSlot!.add(const Duration(minutes: 60)),
      finalPrice: 100,
      finalDuration: 60,
      status: AppointmentStatus.pending,
      createdAt: DateTime.now(),
    );

    try {
      await _useCase(appointment);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Agendamento enviado para aprovação!"),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Novo Agendamento")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                setState(() => selectedDate = date);
                await _loadSlots();
              },
              child: const Text("Selecionar Data"),
            ),
            const SizedBox(height: 20),

            if (availableSlots.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: availableSlots.length,
                  itemBuilder: (context, index) {
                    final slot = availableSlots[index];
                    final isSelected = selectedSlot == slot;

                    return Card(
                      color: isSelected
                          ? Colors.green.shade100
                          : null,
                      child: ListTile(
                        title: Text(
                          "${slot.hour.toString().padLeft(2, '0')}:${slot.minute.toString().padLeft(2, '0')}",
                        ),
                        onTap: () {
                          setState(() {
                            selectedSlot = slot;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: loading ? null : _createAppointment,
              child: loading
                  ? const CircularProgressIndicator(
                color: Colors.white,
              )
                  : const Text("Confirmar Agendamento"),
            ),
          ],
        ),
      ),
    );
  }
}