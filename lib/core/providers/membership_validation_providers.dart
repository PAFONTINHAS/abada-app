import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sistema_abada_capoeira/core/providers/class_providers.dart';
import 'package:sistema_abada_capoeira/features/member_validation/domain/repository/membership_validation_repostitory.dart';
import '../../features/member_validation/data/datasource/membership_validation_remote_datasource.dart';
import '../../features/member_validation/data/datasource/membership_validation_remote_datasource_impl.dart';
import '../../features/member_validation/data/repository/membership_validation_repository_impl.dart';
import '../../features/member_validation/domain/usecases/approve_membership_request_usecase.dart';
import '../../features/member_validation/domain/usecases/get_professor_membership_requests_usecase.dart';
import '../../features/member_validation/domain/usecases/reject_membership_request_usecase.dart';
import '../../features/member_validation/domain/usecases/request_membership_changes_usecase.dart';
import '../../features/member_validation/presentation/controllers/membership_validation_controller.dart';

class MembershipValidationProviders {
  //Representa como tudo dessa feature é montado
  MembershipValidationProviders._();

  static final MembershipValidationRemoteDataSource remoteDataSource = MembershipValidationRemoteDataSourceImpl();
  //quero uma variável seguindo o contrato MembershipValidationRemoteDataSource
  //com a implementação real DataSource, aqui está seu telefone para falar com o Firebase

  static final MembershipValidationRepository repository = MembershipValidationRepositoryImpl(remoteDataSource);
  //crie uma variavel seguindo o contrato
  // o RepositoryImpl precisa de alguém que realmente fale com o banco

  static final GetProfessorMembershipRequestsUseCase getProfessorRequests = GetProfessorMembershipRequestsUseCase(repository);
  //quando precisar buscar, use esse Repository

  static final ApproveMembershipRequestUseCase approveMembershipRequest =
      ApproveMembershipRequestUseCase(repository, ClassProviders.classRepository);
  //quando precisar aprovar, use esse Repository

  static final RequestMembershipChangesUseCase requestMembershipChanges = RequestMembershipChangesUseCase(repository);
  //quando precisar de correção, use esse Repository

  static final RejectMembershipRequestUsecase rejectMembershipRequest = RejectMembershipRequestUsecase(repository);
  //quando precisar rejeitar, use esse Repository

  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(
      //“Você será responsável por criar e disponibilizar para a arvore de widgets este Controller.”
      create: (_) => MembershipValidationController(
        //create é uma função, espera parametro/contexto e retorno, o traço significa "existe, mas nao vou usar"
        //quando precisa criar o Provider, faça o seguinte:
        //crie o controller com o constructor com os useCases parametro:variavel criada
        getProfessorRequestsUsecase: getProfessorRequests,
        approveMembershipRequestUsecase: approveMembershipRequest,
        requestMembershipChangesUsecase: requestMembershipChanges,
        rejectMembershipRequestUsecase: rejectMembershipRequest,
      ),
    ),
  ];
}
