import 'package:sistema_abada_capoeira/features/class/domain/entities/schedule_entity.dart';

class ScheduleEntityModel extends ScheduleEntity{

  ScheduleEntityModel({
    required super.scheduleId,
    required super.openingHour,
    required super.closingHour,
    required super.scheduleDays
  });


  factory ScheduleEntityModel.fromSnapshot(Map<String, dynamic> snapshot){



    return ScheduleEntityModel(
      scheduleId: snapshot['scheduleId'],
      openingHour: snapshot['openingHour'],
      closingHour: snapshot['closingHour'],
      scheduleDays: List<int>.from(snapshot['scheduleDays']),
    );

  }


}