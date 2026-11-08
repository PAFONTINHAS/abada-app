import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sistema_abada_capoeira/core/utils/date_controller.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/graduation_history_entity.dart';

class GraduationHistoryEntityModel extends GraduationHistoryEntity{

  
  const GraduationHistoryEntityModel({
    required super.updatedAt,
    required super.eventName,
    required super.updatedBelt,
    required super.previousBelt,
    required super.eventInitDate,
    required super.eventEndingDate,
  });


  factory GraduationHistoryEntityModel.fromSnapshot(DocumentSnapshot document){

    final data = document.data() as Map<String, dynamic>;
    
    final eventInitDate = DateController.toDate(data['eventInitDate']);
    final updatedAt = DateController.toDate(data['serverGraduationTime']);
    final eventEndingDate = DateController.toDate(data['eventEndingDate']);

    return GraduationHistoryEntityModel(
      eventName: data['eventName'],
      updatedBelt: data['updatedBelt'],
      previousBelt: data['previousBelt'],
      updatedAt: updatedAt ?? DateTime.now(),
      eventInitDate: eventInitDate ?? DateTime.now(),
      eventEndingDate: eventEndingDate ?? DateTime.now(),
    );
  }
}