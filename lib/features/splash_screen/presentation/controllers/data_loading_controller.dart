import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/class_controller.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/acess_profile.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';

class DataLoadingController extends ChangeNotifier{

  double _progress = 0.0;
  String _progressText = "Iniciando...";

  double get progress => _progress;
  String get progressText => _progressText;

  final List<String> _loadingSteps = [
    "Pegando dados do usuário",
    "Carregando turmas do usuário",
    "Finalizando Configurações"
  ];

  int _currentStepIndex = 0;

  void nextStep(){
    if(_currentStepIndex < _loadingSteps.length){
      _progressText = _loadingSteps[_currentStepIndex];

      _currentStepIndex++;

      _progress = _currentStepIndex / _loadingSteps.length;

      notifyListeners();
    }
  }

  Future<void> fetchUserData(AuthController authController, ProfileController profileController) async{

    nextStep();

    await profileController.getUserProfile(authController.user!.uid);

  }

  Future<void> fetchAttendedClasses(ClassController classController, ProfileController profileController) async{

    nextStep();

    final attendedClassesId = profileController.userProfile.attendedClasses;

    await classController.getAttendedClasses(attendedClassesId);
  }

  Future<void> fetchLecturedClasses(ClassController classController, ProfileController profileController) async{

    final lecturedClassesId = profileController.userProfile.lecturedClasses;

    await classController.getLecturedClasses(lecturedClassesId);
  }

  Future<void> finishSplash(AuthController authController, UserRole userRole) async{

    nextStep();

    authController.setAuthenticatedUser(role: userRole);  
  }



}