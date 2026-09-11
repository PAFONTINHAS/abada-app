import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/profile_change_request_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/user_profile_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/repository/profile_repository.dart';

class RequestBeltNicknameChangeUseCase {
  final ProfileRepository repository;

  RequestBeltNicknameChangeUseCase(this.repository);

  Future<Either<Failure, void>> execute({

    required UserProfileEntity userProfile,
    required String originalBelt,
    required String originalNickname,
    String? newBelt,
    String? newNickname,
  }) async {
    
    if (newBelt == null && newNickname == null) {
      return const Left(
        ValidationFailure('Informe uma nova corda ou apelido.'),
      );
    }

    final checkPendingRequests = await repository.checkPendingChangeRequests(userProfile.uid);


    return checkPendingRequests.fold((failure) => Left(failure), (hasPendingChangeRequest) async{

      if(hasPendingChangeRequest) return Left(ValidationFailure("Já existe uma solicitação pendente para esse perfil"));


      final ProfileChangeRequestEntity profileChangeRequestEntity = ProfileChangeRequestEntity(
        id: '',
        userId: userProfile.uid,
        userName: userProfile.fullName,
        originalBelt: originalBelt,
        originalNickname: originalNickname,
        status: ProfileChangeRequestStatus.pending,
        newBelt: newBelt,
        newNickname: newNickname,
        requestDate: DateTime.now()
      );

     return await repository.createChangeRequest(profileChangeRequestEntity);

    });

  }
}
