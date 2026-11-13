import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_migration_request_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/usecases/standard_class_usecase.dart';
import 'package:sistema_abada_capoeira/features/member_validation/domain/entities/membership_request.dart';
import 'package:sistema_abada_capoeira/features/member_validation/domain/repository/membership_validation_repostitory.dart';

class CreateClassMigrationRequestUsecase extends StandardClassUsecase{


  CreateClassMigrationRequestUsecase(super.classRepository, this.membershipValidationRepository);

  MembershipValidationRepository membershipValidationRepository;

  Future<Either<Failure, void>> call(ClassMigrationRequestEntity migrationRequest) async{
    
    final classEntryRequest = migrationRequest.classRequestEntryEntity;

    MembershipRequest request = MembershipRequest(
      id: '',
      requestedAt: DateTime.now(),
      classId: classEntryRequest.classId,
      memberId: migrationRequest.memberId,
      className: classEntryRequest.classUnit,
      memberBelt: migrationRequest.memberBelt,
      memberName: migrationRequest.memberName,
      professorId: classEntryRequest.professorId,
      memberNickname: migrationRequest.memberNickname,
      changeReason: migrationRequest.changeReason
    );

    final sendRequest = await membershipValidationRepository.createMembershipRequest(request);

    return sendRequest.fold((failure) => Left(failure), (_) async{

      return await classRepository.removeStudentFromClass(
        migrationRequest.memberId,
        migrationRequest.currentClassId,
      );
    });
  }
}