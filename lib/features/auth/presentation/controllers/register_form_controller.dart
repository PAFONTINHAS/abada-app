import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_registration_params.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/usecases/register_user_usecase.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/models/register_phase.dart';

class RegisterFormController extends ChangeNotifier {

  RegisterUserUsecase _registerUserUsecase;

  RegisterFormController(this._registerUserUsecase);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get isFirstPhaseComplete{

    if(fullNameController.text.isEmpty) return false;
    if(phoneController.text.isEmpty) return false;
    if(emailController.text.isEmpty) return false;
    if(passwordController.text.isEmpty) return false;
    if(confirmPasswordController.text.isEmpty) return false;

    return true;
  }

  RegisterPhase _registerPhase = RegisterPhase.firstPhase;
  RegisterPhase get registerPhase => _registerPhase;

  void returnToPreviousPhase(){

    _registerPhase = RegisterPhase.firstPhase;

    notifyListeners();

  }

  void moveToTheNextPhase(){

    if(!isFirstPhaseComplete) return;

    _registerPhase = RegisterPhase.secondPhase;

    notifyListeners();
  }

  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController ropeController = TextEditingController();
  TextEditingController professorController = TextEditingController();

  UserRegistrationParams _buildUserRegistrationEntity(){

    return UserRegistrationParams(
      fullName: fullNameController.text,
      email: emailController.text,
      phone: phoneController.text,
      rope: ropeController.text,
      nickname: nicknameController.text,
      password: passwordController.text,
      professor: professorController.text,
      confirmPassword: confirmPasswordController.text,
    );
    
  }

  Future<bool> registerUser() async{

    final UserRegistrationParams user = _buildUserRegistrationEntity();

    final result = await _registerUserUsecase.call(user);

    final success = result.fold((failure){

      _errorMessage = failure.message;

      return false;

    }, (_){

      LoggingService.displayInfo("Deu boa");
      
      return true;
    });

    return success;
    
  }
}