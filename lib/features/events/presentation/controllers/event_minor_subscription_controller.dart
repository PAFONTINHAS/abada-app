import 'package:flutter/material.dart';

class EventMinorSubscriptionController extends ChangeNotifier {


  final studentNameController = TextEditingController();
  final studentGraduationController = TextEditingController();
  final studentNicknameController = TextEditingController();
  final guardianNameController = TextEditingController();
  final guardianPhoneController = TextEditingController();

  bool _hasGuardianConsent = false;
  bool get hasGuardianConsent => _hasGuardianConsent;

  @override
  void dispose() {
    studentNameController.dispose();
    studentGraduationController.dispose();
    studentNicknameController.dispose();
    guardianNameController.dispose();
    guardianPhoneController.dispose();
    super.dispose();
  }
  

  void setHasGuardianConsent(bool value){
    _hasGuardianConsent = value;

    notifyListeners();
  }

}