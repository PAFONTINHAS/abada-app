import 'package:flutter/foundation.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/profile_change_request_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/usecases/get_change_requests_usecase.dart';

class RequestStatusController extends ChangeNotifier {
  final GetChangeRequestsUseCase _getChangeRequestsUseCase;

  bool _isLoading = true;
  ProfileChangeRequestEntity? _latestRequest;
  String? errorMessage;

  bool get isLoading => _isLoading;
  ProfileChangeRequestEntity? get latestRequest => _latestRequest;

  RequestStatusController(this._getChangeRequestsUseCase) {
    loadStatus();
  }

  Future<void> loadStatus() async {
    final result = await _getChangeRequestsUseCase.execute();
    result.fold(
      (failure) {
        errorMessage = failure.message;
        _latestRequest = null;
        _isLoading = false;
      },
      (requests) {
        _latestRequest = requests.isEmpty ? null : requests.first;
        _isLoading = false;
      },
    );
    notifyListeners();
  }
}
