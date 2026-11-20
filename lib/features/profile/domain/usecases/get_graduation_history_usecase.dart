import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/graduation_history_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/usecases/standard_profile_usecase.dart';

class GetGraduationHistoryUsecase extends StandardProfileUsecase{
  
  GetGraduationHistoryUsecase(super.profileRepository);


  Future<Either<Failure, List<GraduationHistoryEntity>>> call(String userId) async {

    return profileRepository.getGraduationHistory(userId);
  }



}