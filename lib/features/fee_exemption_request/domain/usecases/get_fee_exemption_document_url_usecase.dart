import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repository/fee_exemption_repository.dart';

class GetFeeExemptionDocumentUrlUsecase {
  final FeeExemptionRepository repository;

  GetFeeExemptionDocumentUrlUsecase(this.repository);

  Future<Either<Failure, String>> call(String storagePath) async {
    return await repository.getDocumentDownloadUrl(storagePath);
  }
}
