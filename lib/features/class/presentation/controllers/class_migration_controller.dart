import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_migration_request_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_request_entry_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/usecases/create_class_migration_request_usecase.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/user_profile_entity.dart';

class ClassMigrationController extends ChangeNotifier{

  final CreateClassMigrationRequestUsecase classMigrationRequestUsecase;

  ClassMigrationController(this.classMigrationRequestUsecase);

  TextEditingController migrationReason = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ClassMigrationRequestEntity _buildMigrationRequestEntity(
    ClassRequestEntryEntity classRequestEntryEntity,
    UserProfileEntity user,
    String currentClassId,
  ) {

    return ClassMigrationRequestEntity(
      classRequestEntryEntity: classRequestEntryEntity,
      memberBelt: user.currentBelt,
      memberId: user.uid,
      memberName: user.fullName,
      memberNickname: user.nickname,
      currentClassId: currentClassId,
      changeReason: migrationReason.text.trim()
    );
  }


  Future<bool> createMigrationRequest(
    ClassRequestEntryEntity classRequestEntryEntity,
    UserProfileEntity user,
    String currentClassId,
  ) async {
    final migrationRequestEntity = _buildMigrationRequestEntity(
      classRequestEntryEntity,
      user,
      currentClassId,
    );

    final result = await classMigrationRequestUsecase.call(
      migrationRequestEntity,
    );

    return result.fold((failure){
      _errorMessage = failure.message;

      return false;
    }, (_){

      return true;

    });
  }
}