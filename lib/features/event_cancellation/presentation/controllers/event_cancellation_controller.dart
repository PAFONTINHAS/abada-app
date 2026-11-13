import 'package:flutter/foundation.dart';
import 'package:sistema_abada_capoeira/features/event/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/domain/entities/event_cancellation_request_entity.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/domain/usecases/request_event_cancellation_usecase.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/domain/usecases/review_event_cancellation_usecase.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/domain/usecases/get_pending_event_cancellation_requests_usecase.dart';

class EventCancellationController extends ChangeNotifier {
  EventCancellationController(
    this.requestEventCancellationUseCase,
    this.reviewEventCancellationUseCase,
    this.getPendingEventCancellationRequestsUseCase,
  );

  final RequestEventCancellationUseCase requestEventCancellationUseCase;
  final ReviewEventCancellationUseCase reviewEventCancellationUseCase;
  final GetPendingEventCancellationRequestsUseCase
  getPendingEventCancellationRequestsUseCase;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<EventCancellationRequestEntity> _pendingRequests = [];
  List<EventCancellationRequestEntity> get pendingRequests => _pendingRequests;

  Future<EventCancellationRequestEntity?> requestCancellation({
    required EventEntity event,
    required String requesterId,
    required String reason,
    required String details,
  }) async {
    _setLoading(true);
    final result = await requestEventCancellationUseCase(
      event: event,
      requesterId: requesterId,
      reason: reason,
      details: details,
    );
    _setLoading(false);

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        return null;
      },
      (request) {
        _errorMessage = null;
        return request;
      },
    );
  }

  Future<void> loadPendingRequests() async {
    _setLoading(true);
    final result = await getPendingEventCancellationRequestsUseCase();
    _setLoading(false);

    result.fold((failure) => _errorMessage = failure.message, (requests) {
      _errorMessage = null;
      _pendingRequests = requests;
    });
    notifyListeners();
  }

  Future<bool> reviewCancellation({
    required EventCancellationRequestEntity request,
    required bool approve,
    required String reviewerId,
  }) async {
    _setLoading(true);
    final result = await reviewEventCancellationUseCase(
      request: request,
      approve: approve,
      reviewerId: reviewerId,
    );
    _setLoading(false);

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (reviewedRequest) {
        _errorMessage = null;
        _pendingRequests = _pendingRequests
            .where((item) => item.id != reviewedRequest.id)
            .toList();
        notifyListeners();
        return true;
      },
    );
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
