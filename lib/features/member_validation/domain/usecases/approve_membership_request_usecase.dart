//executa uma ação específica do ator, declarado no repository
//representa uma regra de negócio
import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/features/class/domain/repository/class_repository.dart';
import 'package:sistema_abada_capoeira/features/member_validation/domain/entities/membership_request.dart';
import '../../../../core/errors/failure.dart';
import '../repository/membership_validation_repostitory.dart';

class ApproveMembershipRequestUseCase {
  //aprova uma solicitação de vinculo quando apelido e corda = corretos
  //finaliza o processo de solicitação

  final ClassRepository classRepository;
  final MembershipValidationRepository membershipRepository;
  //cria uma variavel chamada repository do tipo MembershipValidationRepository

  ApproveMembershipRequestUseCase(this.membershipRepository, this.classRepository);
  //constructor da classe, recebe as variaveis definidas

  Future<Either<Failure, void>> call(MembershipRequest request) async {
    //nao retorna nenhum dado do banco, é só ida, não volta

    final approveRequest = await membershipRepository.approveRequest(request.id);

    return approveRequest.fold((failure) => Left(failure), (_) async{
      return await classRepository.addStudentToClass(request.memberId, request.classId);
    });
  }
}
