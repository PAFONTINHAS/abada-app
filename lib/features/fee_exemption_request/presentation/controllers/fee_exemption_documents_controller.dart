// carregar histórico/versões dos documentos
// GetFeeExemptionDocumentsUsecase
import 'package:flutter/foundation.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/domain/usecases/get_fee_exemption_document_url_usecase.dart';
import '../../domain/entities/fee_exemption_document_entity.dart';
import '../../domain/usecases/get_fee_exemption_documents_usecase.dart';

class FeeExemptionDocumentsController extends ChangeNotifier {
  final GetFeeExemptionDocumentsUsecase getFeeExemptionDocumentsUsecase;
  final GetFeeExemptionDocumentUrlUsecase getFeeExemptionDocumentUrlUsecase;

  FeeExemptionDocumentsController({
    required this.getFeeExemptionDocumentsUsecase,
    required this.getFeeExemptionDocumentUrlUsecase,
  });

  //estados
  List<FeeExemptionDocumentEntity> documents = [];
  bool isLoading = false;
  String? errorMessage;

  // Busca e carrega todas as versões de PDFs vinculadas a uma solicitação
  Future<bool> getLoadDocuments(String feeExemptionId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await getFeeExemptionDocumentsUsecase(feeExemptionId);

    final success = result.fold(
      (failure) {
        errorMessage = failure.message;
        documents = [];
        return false;
      },
      (loadedDocuments) {
        documents = loadedDocuments;
        return true;
      },
    );

    isLoading = false;
    notifyListeners();
    return success;
  }

  Future<String?> getDocumentUrl(String storagePath) async {
    errorMessage = null;

    final result = await getFeeExemptionDocumentUrlUsecase(storagePath);

    return result.fold(
      (failure) {
        errorMessage = failure.message;
        notifyListeners();
        return null;
      },
      (downloadUrl) {
        return downloadUrl;
      },
    );
  }
}
