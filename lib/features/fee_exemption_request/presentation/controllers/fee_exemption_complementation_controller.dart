// enviar novo PDF após pedido da TUSCA
// SubmitFeeExemptionComplementationUsecase

// 7.3 FeeExemptionComplementationController
//     ├── arquivo selecionado
//     ├── loading
//     ├── errorMessage
//     └── submitComplementation()

import 'package:flutter/foundation.dart';
import '../../domain/entities/fee_exemption_file_entity.dart';
import '../../domain/usecases/submit_fee_exemption_complementation_usecase.dart';

class FeeExemptionComplementationController extends ChangeNotifier {
  final SubmitFeeExemptionComplementationUsecase submitFeeExemptionComplementationUsecase;
  
  FeeExemptionComplementationController({
    required this.submitFeeExemptionComplementationUsecase,
  });

  FeeExemptionFileEntity? selectedFile;
  //o ? quer dizer que pode ser null
  bool isLoading = false;
  String? errorMessage;

  // Guarda temporariamente o novo arquivo selecionado pelo
  //professor antes do enviar a solicitação para o Firebase.
  void selectFile(FeeExemptionFileEntity file) {
    selectedFile = file;
    notifyListeners();
  }

  // Remove o arquivo selecionado antes do envio, ele desistiu e saiu
  void clearSelectedFile() {
    selectedFile = null;
    notifyListeners();
  }

  Future<bool> submitComplementation(String feeExemptionId,
  ) async {
    if (selectedFile == null) {
      errorMessage = 'Selecione a declaração antes de enviar.';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await submitFeeExemptionComplementationUsecase(
      feeExemptionId,
      selectedFile!,
      // o ! diz que NAO é null
    );

    final success = result.fold(
      (failure) {
        errorMessage = failure.message;
        return false;
      },
      (_) {
        selectedFile = null;
        return true;
      },
    );
  isLoading = false;
    notifyListeners();

    return success;
  }
}
