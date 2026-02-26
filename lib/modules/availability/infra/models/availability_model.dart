import '../../domain/entities/availability.dart';

class AvailabilityModel extends Availability {
  AvailabilityModel({
    required super.id,
    required super.professionalId,
    required super.weekday,
    required super.startMinutes,
    required super.endMinutes,
    super.breakStartMinutes,
    super.breakEndMinutes,
  });

  factory AvailabilityModel.fromMap(
      Map<String, dynamic> map, String id) {
    return AvailabilityModel(
      id: id,
      professionalId: map['professionalId'],
      weekday: map['weekday'],
      startMinutes: map['startMinutes'],
      endMinutes: map['endMinutes'],
      breakStartMinutes: map['breakStartMinutes'],
      breakEndMinutes: map['breakEndMinutes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'professionalId': professionalId,
      'weekday': weekday,
      'startMinutes': startMinutes,
      'endMinutes': endMinutes,
      'breakStartMinutes': breakStartMinutes,
      'breakEndMinutes': breakEndMinutes,
    };
  }
}