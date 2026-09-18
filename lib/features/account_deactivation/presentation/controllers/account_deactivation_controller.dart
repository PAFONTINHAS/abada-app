import 'package:flutter/foundation.dart';
import 'package:sistema_abada_capoeira/features/account_deactivation/domain/usecases/deactivate_account_usecase.dart';

class AccountDeactivationController extends ChangeNotifier {
  final DeactivateAccountUseCase _deactivateAccountUseCase;

  AccountDeactivationController(this._deactivateAccountUseCase);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> deactivateAccount(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _deactivateAccountUseCase.execute(userId);
    final success = result.fold((failure) {
      _errorMessage = failure.message;
      return false;
    }, (_) => true);

    _isLoading = false;
    notifyListeners();
    return success;
  }
}
