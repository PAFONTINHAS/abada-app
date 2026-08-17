import 'package:flutter/material.dart';

class LoginFormController extends ChangeNotifier{

  
  TextEditingController emailController = TextEditingController();
  TextEditingController passowordController = TextEditingController();



  void fillEmailField(String text){

    if(text.isEmpty) return;

    emailController.text = text;

    notifyListeners();
  }

  void fillPasswordField(String text){

    if(text.isEmpty) return;

    passowordController.text = text;

    notifyListeners();
  }


}