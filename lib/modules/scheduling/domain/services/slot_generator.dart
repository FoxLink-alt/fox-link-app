import '../../../availability/domain/entities/availability.dart';

class SlotGenerator {
  static List<DateTime> generateSlots({
    required DateTime date,
    required int durationMinutes,
    required Availability availability,
  }) {
    final slots = <DateTime>[];

    final start = DateTime(
      date.year,
      date.month,
      date.day,
      availability.startHour,
    );

    final end = DateTime(
      date.year,
      date.month,
      date.day,
      availability.endHour,
    );

    DateTime current = start;

    while (current.add(Duration(minutes: durationMinutes)).isBefore(end) ||
        current.add(Duration(minutes: durationMinutes)).isAtSameMomentAs(end)) {
      final slotEnd = current.add(Duration(minutes: durationMinutes));

      final isBreak = availability.breakStartHour != null &&
          current.hour >= availability.breakStartHour! &&
          current.hour < availability.breakEndHour!;

      if (!isBreak) {
        slots.add(current);
      }

      current = current.add(Duration(minutes: durationMinutes));
    }

    return slots;
  }
}