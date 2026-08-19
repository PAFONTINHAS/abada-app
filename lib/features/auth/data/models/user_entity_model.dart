import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_entity.dart';

class UserEntityModel extends UserEntity{

  UserEntityModel({

    required super.uid,
    required super.fullName,
    required super.email,
    required super.phone,
    required super.rope,
    required super.nickname,
    required super.professor,
    super.userRole
  }); 


  factory UserEntityModel.fromSnapshot(DocumentSnapshot doc){

    if(!doc.exists || doc.data() == null) throw Exception("Documento inválido");

    final Map<String, dynamic> data = doc.data() as Map<String,dynamic>;

    return UserEntityModel(
      uid: doc.id,
      fullName: data['fullName'],
      email: data['email'],
      phone: data['phone'],
      rope: data['rope'],
      nickname: data['nickname'],
      professor: data['professor'],
    );
  }

}