// criar e carregar a solicitação
// SubmitFeeExemptionUsecase + GetProfessorFeeExemptionUseca

import 'package:flutter/foundation.dart';
import '../../domain/entities/fee_exemption_file_entity.dart';
import '../../domain/entities/fee_exemption_request_entity.dart';
import '../../domain/usecases/get_fee_exemption_request_usecase.dart';
import '../../domain/usecases/submit_fee_exemption_usecase.dart';

class FeeExemptionRequestController extends ChangeNotifier {
  final SubmitFeeExemptionUsecase submitFeeExemptionUsecase;
  final GetFeeExemptionRequestUsecase getFeeExemptionRequestUsecase;

  FeeExemptionRequestController({
    //pro controller funcionar ele chama os usecases pra acessar as solicitações
    required this.submitFeeExemptionUsecase,
    required this.getFeeExemptionRequestUsecase,
  });

 //estados que o controller vai controllar
 //dados que podem mudar enquanto o usuário usa a tela
  FeeExemptionRequestEntity? request;
  FeeExemptionFileEntity? selectedFile; //o pdf
  bool isLoading = false;
  String? errorMessage;

  // Guarda o arquivo selecionado pelo professor antes do enviar a solicitação para o Firebase.
  void selectFile(FeeExemptionFileEntity file) {
    selectedFile = file;
    notifyListeners();
  }

  // Remove o arquivo selecionado antes do envio, ele desistiu e saiu
  void clearSelectedFile() {
    selectedFile = null;
    notifyListeners();
  }

  // Envia uma nova solicitação de isenção.
  Future<String?> submitRequest(FeeExemptionRequestEntity request,
  ) async {
    if (selectedFile == null) {
      errorMessage = 'Selecione a declaração antes de enviar.';
      notifyListeners();
      return null;
    }

    isLoading = true; //começou a operação, aguarde
    errorMessage = null; //limpando a const
    notifyListeners(); //Controller mudou. Avise as telas/widgets que estão ouvindo este Controller

    final result = await submitFeeExemptionUsecase(
      //chama o usecase passando oq ele precisa pra trabalhar
      request: request,
      file: selectedFile!,
    );

    final feeExemptionId = result.fold(
      //.fold pega o resultado e designa
      (failure) {
        errorMessage = failure.message;
        return null;
        //Left: A solicitação não foi enviada.
      },
      (createdId) {
        //como é Right(null), nao precisa colocar nada nos ()
        this.request = request;
        //Pegue a solicitação recebida pelo método e guarde como a solicitação atual do Controller.
        selectedFile = null;
        return createdId;
      },
    );

    isLoading = false; //ja terminou a operação
    notifyListeners(); //mudou a tela
    return feeExemptionId;
  }

  // Busca uma solicitação específica pelo ID, tipo um get
  Future<bool> getLoadRequest(String feeExemptionId,
  ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await getFeeExemptionRequestUsecase(feeExemptionId,);

    final success = result.fold(
      (failure) {
        errorMessage = failure.message;
        request = null;
        return false;
      },
      (loadedRequest) {
        request = loadedRequest;
        return true;
      },
    );

    isLoading = false;
    notifyListeners();
    return success;
  }
}