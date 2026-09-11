import 'package:flutter/material.dart';

class RejectRequestDialogController extends ChangeNotifier {
  String? selectedReason;
  bool isLoading = false;

  final TextEditingController otherReasonController =
      TextEditingController();

  void selectReason(String reason) {
    selectedReason = reason;
    notifyListeners();
  }

  String? validate() {
    if (selectedReason == null) {
      return 'Selecione um motivo para a rejeição.';
    }

    if (selectedReason == 'Outro motivo' &&
        otherReasonController.text.trim().isEmpty) {
      return 'Informe o motivo da rejeição.';
    }

    return null;
  }

  Future<bool> confirm(
    Future<bool> Function(String reason) onConfirm,
  ) async {
    String reason = selectedReason!;

    if (selectedReason == 'Outro motivo') {
      reason = otherReasonController.text.trim();
    }

    isLoading = true;
    notifyListeners();

    try {
      return await onConfirm(reason);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    otherReasonController.dispose();
    super.dispose();
  }
}