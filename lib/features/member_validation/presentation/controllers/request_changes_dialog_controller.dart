import 'package:flutter/material.dart';

class RequestChangesDialogController extends ChangeNotifier {
  bool beltSelected = false;
  bool nicknameSelected = false;
  bool classSelected = false;
  bool isLoading = false;

  final TextEditingController detailsController =
      TextEditingController();

  void toggleBelt(bool value) {
    beltSelected = value;
    notifyListeners();
  }

  void toggleNickname(bool value) {
    nicknameSelected = value;
    notifyListeners();
  }

  void toggleClass(bool value) {
    classSelected = value;
    notifyListeners();
  }

  String? validate() {
    if (!beltSelected &&
        !nicknameSelected &&
        !classSelected) {
      return 'Selecione pelo menos uma correção.';
    }

    return null;
  }

  String buildReason() {
    final reasons = <String>[];

    if (beltSelected) {
      reasons.add('Corda incorreta');
    }

    if (nicknameSelected) {
      reasons.add('Apelido incorreto');
    }

    if (classSelected) {
      reasons.add('Não pertence à turma');
    }

    final details = detailsController.text.trim();

    String reason = reasons.join(', ');

    if (details.isNotEmpty) {
      reason = '$reason. Detalhes: $details';
    }

    return reason;
  }

  Future<bool> confirm(
    Future<bool> Function(String reason) onConfirm,
  ) async {
    isLoading = true;
    notifyListeners();

    try {
      return await onConfirm(buildReason());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    detailsController.dispose();
    super.dispose();
  }
}