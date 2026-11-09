import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/minor_student_subscription_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_subscription_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/subscribe_minor_to_event_usecase.dart';

class EventMinorSubscriptionController extends ChangeNotifier {

  final SubscribeMinorToEventUsecase _subscribeMinorToEventUsecase;

  EventMinorSubscriptionController(this._subscribeMinorToEventUsecase);

  final studentNameController = TextEditingController();
  final studentGraduationController = TextEditingController();
  final studentNicknameController = TextEditingController();
  final guardianNameController = TextEditingController();
  final guardianPhoneController = TextEditingController();

  bool _hasGuardianConsent = false;
  bool get hasGuardianConsent => _hasGuardianConsent;
  
  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;


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

  MinorStudentSubscriptionEntity _buildMinorSubscriptionData(){

    return MinorStudentSubscriptionEntity(
      studentNickname: studentNicknameController.text.trim(),
      studentFullName: studentNameController.text.trim(),
      legalGuardianName: guardianNameController.text.trim(),
      studentCurrentBelt: studentGraduationController.text.trim(),
      legalGuardianPhoneNumber: guardianPhoneController.text.trim(),
      hasLegalGuardianConsent: _hasGuardianConsent,
    );
  }


  Future<EventSubscriptionEntity?> subscribeMinorToEvent(EventSubscriptionEntity subscription) async{

    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    final minorSubscriptionData = _buildMinorSubscriptionData();


    final updatedSubscription = subscription.copyWith(
      minorStudentSubscriptionData: minorSubscriptionData,
    );

    final result = await _subscribeMinorToEventUsecase.call(updatedSubscription);


    final success = result.fold((failure) {
      _errorMessage = failure.message;
      return null;
    }, (subscription){

      return subscription;
    });

    _isProcessing = false;
    notifyListeners();

    return success;
  }

}