// FeeExemptionRemoteDataSourceImpl
//         ↓
// FeeExemptionRepositoryImpl
//         ↓
// UseCases
//         ↓
// FeeExemptionRequestController
// FeeExemptionDocumentsController
// FeeExemptionComplementationController
//         ↓
// ChangeNotifierProvider

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/data/datasource/fee_exemption_remote_datasource.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/data/datasource/fee_exemption_remote_datasource_impl.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/data/repository/fee_exemption_repository_impl.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/domain/repository/fee_exemption_repository.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/domain/usecases/get_fee_exemption_document_url_usecase.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/domain/usecases/get_fee_exemption_documents_usecase.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/domain/usecases/get_fee_exemption_request_usecase.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/domain/usecases/submit_fee_exemption_complementation_usecase.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/domain/usecases/submit_fee_exemption_usecase.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/presentation/controllers/fee_exemption_complementation_controller.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/presentation/controllers/fee_exemption_documents_controller.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/presentation/controllers/fee_exemption_request_controller.dart';

class FeeExemptionProviders {
  FeeExemptionProviders._();

  static final FeeExemptionRemoteDataSource remoteDataSource =
      FeeExemptionRemoteDataSourceImpl();
  static final FeeExemptionRepository repository = FeeExemptionRepositoryImpl(
    remoteDataSource,
  );
  static final GetFeeExemptionRequestUsecase getFeeExemptionRequestUsecase =
      GetFeeExemptionRequestUsecase(repository);
  static final SubmitFeeExemptionUsecase submitFeeExemptionUsecase =
      SubmitFeeExemptionUsecase(repository);
  static final GetFeeExemptionDocumentsUsecase getFeeExemptionDocumentsUsecase =
      GetFeeExemptionDocumentsUsecase(repository);
  static final SubmitFeeExemptionComplementationUsecase
  submitFeeExemptionComplementationUsecase =
      SubmitFeeExemptionComplementationUsecase(repository);
  static final GetFeeExemptionDocumentUrlUsecase
  getFeeExemptionDocumentUrlUsecase = GetFeeExemptionDocumentUrlUsecase(
    repository,
  );
  static final FeeExemptionRequestController requestController =
      FeeExemptionRequestController(
        submitFeeExemptionUsecase: submitFeeExemptionUsecase,
        getFeeExemptionRequestUsecase: getFeeExemptionRequestUsecase,
      );

  static final FeeExemptionDocumentsController documentsController =
      FeeExemptionDocumentsController(
        getFeeExemptionDocumentsUsecase: getFeeExemptionDocumentsUsecase,
        getFeeExemptionDocumentUrlUsecase: getFeeExemptionDocumentUrlUsecase,
      );

  static final FeeExemptionComplementationController complementationController =
      FeeExemptionComplementationController(
        submitFeeExemptionComplementationUsecase:
            submitFeeExemptionComplementationUsecase,
      );

  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => requestController),
    ChangeNotifierProvider(create: (_) => documentsController),
    ChangeNotifierProvider(create: (_) => complementationController),
  ];
}
