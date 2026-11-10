import 'package:flutter/foundation.dart';

class RequestJustificationDialogController extends ChangeNotifier {
  bool _isSubmitting = false;

  bool get isSubmitting => _isSubmitting;

  void setSubmitting(bool value) {
    if (_isSubmitting == value) return;

    _isSubmitting = value;
    notifyListeners();
  }
}
