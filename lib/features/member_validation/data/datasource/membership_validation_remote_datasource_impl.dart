//acessa e conversa com o firebase

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/features/member_validation/domain/entities/membership_request.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/exception_handler.dart';
import '../../domain/entities/membership_request_status.dart';
import '../model/membership_request_model.dart';
import 'membership_validation_remote_datasource.dart';

class MembershipValidationRemoteDataSourceImpl         implements MembershipValidationRemoteDataSource {
        //criando a classe de implementação do datasource
  //implementa cada ação do data source

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  // Cria uma instância do Firestore dentro da própria classe.

  @override
  Future<Either<Failure, void>> createMembershipRequest (MembershipRequest request) async{
    try {

      final requestModel = MembershipRequestModel.fromEntity(request);

      await firestore.collection("membership_requests").doc().set(requestModel.toMap());

      return Right(null);

    }catch(exception){
      return ExceptionHandler.handleException(exception: exception, contextMessage: "createMembershipRequest");
    }
  }

  //esse método é o buscar todas as solicitações updated ou requested do getProfessorRequests
  @override //significa "esse metodo foi declarado na interface e estou impl aqui"
  Future<Either<Failure, List<MembershipRequestModel>>> getProfessorRequests(
    String professorId,
    // o método chama o get com paramentro de quem é o prof pelo id
    //e retorna no futuro, uma lista onde cada item da lista será uma solicitação transformada em objeto Dart (model)
  ) async {
    try{
      final snapshot = await firestore
          //cria uma variavel chamada snapshot que vai guardar o resultado da busca de dentro do firestore
          .collection('membership_requests')
          //entre na coleção chamada membership etc
          .where('professorId', isEqualTo: professorId)
          //dentro da coleção, procure o doc/obj que o id que eu procuro seja igual ao que eu recebi
          .where(
            //busque as solicitações onde o status:
            'status',
            whereIn: [
              MembershipRequestStatus.requested.name, //seja requested
              MembershipRequestStatus.updated.name, // ou updated
            ],
          )
          .get();
      //resumo: Espere o Firebase buscar na coleção membership_requests todos os documentos
      //cujo professorId seja igual ao professor recebido e guarde o resultado em snapshot

    final requests = snapshot.docs.map((doc) {
      //coloque na variavel os docs encontrados, map()=para cada item da lista faça x com o obj (doc)
      return MembershipRequestModel.fromMap(
        //pegue o doc direto do firebase e transforme para obj/model dart
        doc.id, //passando qual doc
        doc.data(), //o que tem no doc, campos
      );
    }).toList(); //transforma o resultado em lista List<MembershipRequestModel>
    return Right(requests);
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'getProfessorRequests',
      );
    }
  }

  //esse método é o aprovar solicitação
  //do prof x, entre em todas as solicitações dele, e dado
  //uma solicitação em especifico, atualize o status dela para aprovado
  @override
  Future<Either<Failure, void>> approveRequest(String requestId) async {
    try {
      await firestore.collection('membership_requests').doc(requestId).update({
        'status': MembershipRequestStatus.approved.name,
      });
      return const Right(null);
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'approveRequest',
      );
    }
  }

  //esse método é o solicitar correções
  //do prof x, entre em todas as solicitações dele, e dado
  //uma solicitação em especifico com o motivo da correção,
  //atualize o status dela para changesRequested e salve o motivo
  @override
  Future<Either<Failure, void>> requestChanges(String requestId, String changeReason) async {
    try {
      await firestore.collection('membership_requests').doc(requestId).update({
        'status': MembershipRequestStatus.changesRequested.name,
        'changeReason': changeReason, //salva o motivo
      });
      return const Right(null);
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'requestChanges',
      );
    }
  }

  //esse método é o rejeitar solicitação
  //do prof x, entre em todas as solicitações dele, e dado
  //uma solicitação em especifico com o motivo da rejeição,
  //atualize o status dela para rejected e salve o motivo
  @override
  Future<Either<Failure, void>> rejectRequest(String requestId, String rejectionReason) async {
    
    try{
        await firestore.collection('membership_requests').doc(requestId).update({
        'status': MembershipRequestStatus.rejected.name,
        'rejectionReason': rejectionReason,
      });
      return const Right(null);
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'rejectRequest',
      );
    }
  }

  //esse método é o mudar status da solicitação para updated se correções
  //do prof x, entre em todas as solicitações dele, e dado
  //uma solicitação em especifico atualize o status dela para
  //uptaded pq o membro fez as correções e salve a data e horario da atualização
  @override
  Future<Either<Failure, void>> markRequestAsUpdated(String requestId) async {
    try{
      await firestore.collection('membership_requests').doc(requestId).update({
        'status': MembershipRequestStatus.updated.name,
        'updatedAt': FieldValue.serverTimestamp(),
        //quem define o horário é o Firebase, evitando depender do relógio do celular do aluno
      });
      return const Right(null);
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'markRequestAsUpdated',
      );
    }
  }
}
