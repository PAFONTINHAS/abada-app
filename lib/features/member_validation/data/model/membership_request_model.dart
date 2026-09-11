//entidade preparada para conversar com o Firebase.
import '../../domain/entities/membership_request.dart';
import '../../domain/entities/membership_request_status.dart';


class MembershipRequestModel extends MembershipRequest {
  const MembershipRequestModel({
    required super.id, //super significa = herda da classe pai 
    required super.memberId,
    required super.professorId,
    required super.classId,
    required super.status,
    required super.requestedAt,
    super.rejectionReason,
    super.changeReason,
    super.updatedAt,
  });

  factory MembershipRequestModel.fromMap(
    //cria um construtor nomeado chamado fromMap,
    //fromMap pega os dados do firebase/map (List<Map<chave,valor>>)
    //e transforma map em obj para o flutter conseguir entender
    //map                               em         obj
    // {                                ->        MembershipRequestModel(
    // 'memberId': '123',               ->         memberId: '123',
    // 'professorId': '456',            ->         professorId: '456',
    // 'belt': 'Amarela',               ->         belt: 'Amarela',
    // }                                ->          )

    String id,
    //recebe o id da solicitação
    //id é separado dos outros atributos

    Map<String, dynamic> map,
    //recebe os dados da solicitação em formato de map. <chave, valor> texto e !=tipos
  ) {
    return MembershipRequestModel(
      id: id, //nome atributo : string id declarada
      memberId: map['memberId'], //procura no obj map, o valor 'memberId' da chave memberId
      professorId: map['professorId'],
      classId: map['classId'],
      status: MembershipRequestStatus.values.byName(
        //values pega o valor e byName procura num enum o nome do atributo
        map['status'], //procura no obj map um valor 'status'
      ),

      rejectionReason: map['rejectionReason'],
      changeReason: map['changeReason'],
      requestedAt: map['requestedAt'].toDate(),
      //converte uma data que veio do Firebase do tipo Timestamp para o tipo DateTime do Dart.
      updatedAt: map['updatedAt']?.toDate(),
      //se updatedAt não for null, execute toDate, se for null deixe como está.
      //pq pode ser que não houve uma correção de apelido ou corda
    );
  }

  Map<String, dynamic> toMap() {
    //transforma o obj em map para o firebase conseguir entender
    //obj                               em         map
    //  MembershipRequestModel(         ->      {
    //   memberId: '123',               ->      'memberId': '123',
    //   professorId: '456',            ->      'professorId': '456',
    //   belt: 'Amarela',               ->      'belt': 'Amarela',
    //    )                             ->      }
    return {
      'memberId': memberId,
      'professorId': professorId,
      'classId': classId,
      'status': status.name,
      'rejectionReason': rejectionReason,
      'changeReason': changeReason,
      'requestedAt': requestedAt,
      'updatedAt': updatedAt,
    };
  }
}

