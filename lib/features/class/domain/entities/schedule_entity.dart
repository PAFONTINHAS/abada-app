class ScheduleEntity{

  ScheduleEntity({
    required this.scheduleId,
    required this.openingHour,
    required this.closingHour,
    required this.scheduleDays
  });

  final String scheduleId;
  final String openingHour;
  final String closingHour;

  final List<int> scheduleDays;

  Map<String, dynamic> toMap(){
    return{
      'scheduleId': scheduleId,
      'openingHour': openingHour,
      'closingHour': closingHour,
      'scheduleDays': scheduleDays
    };
  }

  ScheduleEntity copyWith({

    final String? scheduleId,
    final String? openingHour,
    final String? closingHour,

    final List<int>? scheduleDays,
  }){

    return ScheduleEntity(
      scheduleId: scheduleId ?? this.scheduleId,
      openingHour: openingHour ?? this.openingHour,
      closingHour: closingHour ?? this.closingHour,
      scheduleDays: scheduleDays ?? this.scheduleDays,
    );

  }

}