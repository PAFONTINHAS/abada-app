import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/request_event_cancellation_usecase.dart';

class EventCancellationController extends ChangeNotifier {
  EventCancellationController(
    this.requestEventCancellationUseCase,
  ){
    reasonController.text = "Imprevisto";
  }

  final RequestEventCancellationUseCase requestEventCancellationUseCase;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  TextEditingController reasonController = TextEditingController();
  TextEditingController detailsController = TextEditingController();


  void setReasonController(String? value){

    if(value == null) return;

    reasonController.text = value;

    notifyListeners();
  }

  void setDetailsController(String value){
    detailsController.text = value;

    notifyListeners();
  }

  Future<EventRequestEntity?> requestCancellation({
    required EventEntity event,
    required String requesterId,
    required String requesterNickname,
  }) async {
    _setLoading(true);
    final result = await requestEventCancellationUseCase.call(
      event: event,
      requesterId: requesterId,
      requesterNickname: requesterNickname,
      reason: reasonController.text.trim(),
      details: detailsController.text.trim(),
    );

    final cancelationRequest = result.fold(
      (failure) {
        _errorMessage = failure.message;
        return null;
      },
      (request) {
        _errorMessage = null;
        return request;
      },
    );
    _setLoading(false);

    return cancelationRequest;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
