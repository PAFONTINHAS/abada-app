import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sistema_abada_capoeira/features/member_validation/domain/repository/membership_validation_repostitory.dart';

import '../../features/member_validation/data/datasource/membership_validation_remote_datasource.dart';
import '../../features/member_validation/data/datasource/membership_validation_remote_datasource_impl.dart';
import '../../features/member_validation/data/repository/membership_validation_repository_impl.dart';
import '../../features/member_validation/domain/usecases/approve_membership_request.dart';
import '../../features/member_validation/domain/usecases/get_professor_membership_requests.dart';
import '../../features/member_validation/domain/usecases/reject_membership_request.dart';
import '../../features/member_validation/domain/usecases/request_membership_changes.dart';
import '../../features/member_validation/presentation/controllers/membership_validation_controller.dart';

class MembershipValidationProvider {
  //Representa como tudo dessa feature é montado
  MembershipValidationProvider._();
  //constructor privado, pq não precisa criar objetos dessa classe pq tudo é static
  //vira um container de dependencias, uma prateleira

  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  //Crie uma variável chamada firestore, do tipo FirebaseFirestore, usando a instância atual do Firestore
  //Firebase, me dê sua instância do Firestore
  //final é pq vai ser a mesma  instancia/banco sempre
  //static pq queremos acessar assim MembershipValidationProvider.firestore
  
  static final MembershipValidationRemoteDataSource remoteDataSource =
  //quero uma variável seguindo o contrato MembershipValidationRemoteDataSource
      MembershipValidationRemoteDataSourceImpl(firestore);
  //implementação real. DataSource, aqui está seu telefone para falar com o Firebase

  static final MembershipValidationRepository repository =
  //crie uma variavel seguindo o contrato
      MembershipValidationRepositoryImpl(remoteDataSource);
  // o RepositoryImpl precisa de alguém que realmente fale com o banco
  
  static final GetProfessorMembershipRequests getProfessorRequests =
      GetProfessorMembershipRequests(repository);
      //quando precisar buscar, use esse Repository

  static final ApproveMembershipRequest approveMembershipRequest =
      ApproveMembershipRequest(repository);
      //quando precisar aprovar, use esse Repository

  static final RequestMembershipChanges requestMembershipChanges =
      RequestMembershipChanges(repository);
      //quando precisar de correção, use esse Repository

  static final RejectMembershipRequest rejectMembershipRequest =
      RejectMembershipRequest(repository);
      //quando precisar rejeitar, use esse Repository

  static List<SingleChildWidget> providers = [
    //crie uma lista de Providers
    ChangeNotifierProvider(
      //“Você será responsável por criar e disponibilizar este Controller.”
      create: (_) => MembershipValidationController(
        //create é uma função, espera parametro/contexto e retorno, o traço significa "existe, mas nao vou usar"
        //quando precisa criar o Provider, faça o seguinte:
        //crie o controller com o constructor com os useCases parametro:variavel criada
        getProfessorRequests: getProfessorRequests,
        approveMembershipRequest: approveMembershipRequest,
        requestMembershipChanges: requestMembershipChanges,
        rejectMembershipRequest: rejectMembershipRequest,
      ),
    ),
  ];
}
