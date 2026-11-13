import 'package:sistema_abada_capoeira/features/class/domain/entities/class_request_entry_entity.dart';

class ClassMigrationRequestEntity {

  ClassMigrationRequestEntity({
    required this.classRequestEntryEntity,
    required this.memberBelt,
    required this.memberId,
    required this.memberName,
    required this.memberNickname,
    required this.currentClassId,
    this.changeReason
  });

  final String memberId;
  final String memberName;
  final String memberBelt;
  final String? changeReason;
  final String memberNickname;
  final String currentClassId;
  final ClassRequestEntryEntity classRequestEntryEntity;

}