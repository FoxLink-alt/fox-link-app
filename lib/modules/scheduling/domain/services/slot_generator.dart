import '../../../availability/domain/entities/availability.dart';

class SlotGenerator {

  static List<DateTime> generateSlots({
    required DateTime date,
    required int durationMinutes,
    required Availability availability,
  }) {

    final slots = <DateTime>[];

    /// Converte minutos absolutos para DateTime do dia escolhido
    final start = DateTime(
      date.year,
      date.month,
      date.day,
    ).add(Duration(minutes: availability.startMinutes));

    final end = DateTime(
      date.year,
      date.month,
      date.day,
    ).add(Duration(minutes: availability.endMinutes));

    DateTime current = start;

    while (
    current
        .add(Duration(minutes: durationMinutes))
        .isBefore(end) ||
        current
            .add(Duration(minutes: durationMinutes))
            .isAtSameMomentAs(end)
    ) {

      final currentMinutes =
          current.hour * 60 + current.minute;

      final isBreak =
          availability.breakStartMinutes != null &&
              availability.breakEndMinutes != null &&
              currentMinutes >= availability.breakStartMinutes! &&
              currentMinutes < availability.breakEndMinutes!;

      if (!isBreak) {
        slots.add(current);
      }

      current =
          current.add(Duration(minutes: durationMinutes));
    }

    return slots;
  }
}