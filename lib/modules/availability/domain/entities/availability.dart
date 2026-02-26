class Availability {
  final String id;
  final String professionalId;
  final int weekday; // 1 = segunda
  final int startMinutes;
  final int endMinutes;
  final int? breakStartMinutes;
  final int? breakEndMinutes;

  Availability({
    required this.id,
    required this.professionalId,
    required this.weekday,
    required this.startMinutes,
    required this.endMinutes,
    this.breakStartMinutes,
    this.breakEndMinutes,
  }) {
    if (startMinutes >= endMinutes) {
      throw Exception("Horário inválido");
    }
  }
}