import 'package:sistema_abada_capoeira/features/events/domain/entities/minor_student_subscription_entity.dart';

class MinorStudentSubscriptionEntityModel extends MinorStudentSubscriptionEntity{

  const MinorStudentSubscriptionEntityModel({
    required super.studentFullName,
    required super.studentNickname,
    required super.studentCurrentBelt,
    required super.legalGuardianName,
    required super.legalGuardianPhoneNumber,
    required super.hasLegalGuardianConsent,
  });


  factory MinorStudentSubscriptionEntityModel.fromSnapshot(Map<String, dynamic> snapshot){

    return MinorStudentSubscriptionEntityModel(
      studentFullName: snapshot['studentFullName'],
      studentNickname: snapshot['studentNickname'],
      studentCurrentBelt: snapshot['studentCurrentBelt'],
      legalGuardianName: snapshot['legalGuardian'],
      legalGuardianPhoneNumber: snapshot['legalGuardianPhoneNumber'],
      hasLegalGuardianConsent: snapshot['hasLegalGuardianConsent'],
    );

  }



  
}