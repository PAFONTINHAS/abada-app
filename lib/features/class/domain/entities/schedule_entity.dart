class ScheduleEntity{

  ScheduleEntity({
    required this.id,
    required this.openingHour,
    required this.closingHour,
    required this.scheduleDays
  });

  final String id;
  final String openingHour;
  final String closingHour;

  final List<int> scheduleDays;

  ScheduleEntity copyWith({

    final String? id,
    final String? openingHour,
    final String? closingHour,

    final List<int>? scheduleDays,
  }){

    return ScheduleEntity(
      id: id ?? this.id,
      openingHour: openingHour ?? this.openingHour,
      closingHour: closingHour ?? this.closingHour,
      scheduleDays: scheduleDays ?? this.scheduleDays,
    );

  }

}