import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_member_entity.dart';

class ClassMemberEntityModel extends ClassMemberEntity{

  const ClassMemberEntityModel({
    required super.belt,
    super.name,
    super.nickname,
    required super.studentId,
    required super.displaySensitiveData, 
  });

  factory ClassMemberEntityModel.fromSnapshot(DocumentSnapshot document){

    final data = document.data() as Map<String,dynamic>;

    return ClassMemberEntityModel(
      studentId: document.id,
      belt: data['belt'],
      displaySensitiveData: data['displaySensitiveData'],
      name: data['name'],
      nickname: data['nickname'],
    );

  }


}