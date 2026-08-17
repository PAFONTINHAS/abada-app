import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/models/register_phase.dart';

class RegisterFormController extends ChangeNotifier {

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

    // if(!isFirstPhaseComplete) return;

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



}