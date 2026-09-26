import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/usecases/create_class_usecase.dart';
import 'package:sistema_abada_capoeira/features/class/domain/usecases/get_attended_classes_usecase.dart';
import 'package:sistema_abada_capoeira/features/class/domain/usecases/get_lectured_classes_usecase.dart';
import 'package:sistema_abada_capoeira/features/class/domain/usecases/update_class_usecase.dart';

class ClassController extends ChangeNotifier{

  final UpdateClassUsecase _updateClassUsecase;
  final CreateClassUsecase _createClassUsecase;
  final GetAttendedClassesUsecase _getAttendedClassesUsecase;
  final GetLecturedClassesUsecase _getLecturedClassesUsecase;

  ClassController(
    this._createClassUsecase,
    this._updateClassUsecase,
    this._getAttendedClassesUsecase,
    this._getLecturedClassesUsecase,
  );

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<ClassEntity> _attendedClasses = [];
  List<ClassEntity> get attendedClasses => _attendedClasses;

  List<ClassEntity> _lecturedClasses = [];
  List<ClassEntity> get lecturedClasses => _lecturedClasses;

  Future<bool> createClassUsecase(ClassEntity classEntity) async{

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    final result = await _createClassUsecase.call(classEntity);

    final success = result.fold(
      (failure){
        _errorMessage = failure.message;
        return false;
      }, (createdClass){

        LoggingService.displayInfo("Created Class: ${createdClass.toMap()}");

        final List<ClassEntity> currentLecturedClasses = List.from(_lecturedClasses);


        currentLecturedClasses.add(createdClass);

        _lecturedClasses = List.from(currentLecturedClasses);


        return true;
      });

    _isLoading = false;

    notifyListeners();

    for(final classEntity in _lecturedClasses){


      LoggingService.displayInfo("Class: ${classEntity.toMap()} ");
    }
    return success;
  }

  Future<bool> updateClassUsecase(ClassEntity classEntity) async{

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    final result = await _updateClassUsecase.call(classEntity);

    final success = result.fold(
      (failure){
        _errorMessage = failure.message;
        return false;
      }, (updatedClass){

        final List<ClassEntity> currentLecturedClasses = List.from(_lecturedClasses);

        currentLecturedClasses.removeWhere((classEntity) => classEntity.classId == updatedClass.classId);
        
        currentLecturedClasses.add(updatedClass);

        _lecturedClasses = List.from(currentLecturedClasses);

        return true;
      });

    _isLoading = false;

    notifyListeners();

    return success;
  }

  Future<bool> getAttendedClasses(List<String> attendedClassesId) async {

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _getAttendedClassesUsecase.call(attendedClassesId);

    final success = result.fold(
      (failure){
        _errorMessage = failure.message;
        return false;
      }, (fetchedAttendedClasses){

        _attendedClasses = List.from(fetchedAttendedClasses);

        return true;
        
      });

    _isLoading = false;
    notifyListeners();

    return success;
  }

  Future<bool> getLecturedClasses(List<String> lecturedClassesId) async {

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _getLecturedClassesUsecase.call(lecturedClassesId);

    final success = result.fold(
      (failure){
        _errorMessage = failure.message;
        return false;
      }, (fetchedLecturedClasses){

        _lecturedClasses = List.from(_lecturedClasses)..addAll(fetchedLecturedClasses);

        return true;
        
      });

    _isLoading = false;
    notifyListeners();

    return success;
  }


}