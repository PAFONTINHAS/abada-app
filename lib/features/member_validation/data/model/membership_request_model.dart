//entidade preparada para conversar com o Firebase.
import '../../domain/entities/membership_request.dart';
import '../../domain/entities/membership_request_status.dart';


class MembershipRequestModel extends MembershipRequest {
  const MembershipRequestModel({
    super.updatedAt,
    super.changeReason,
    super.rejectionReason,

    required super.id, //super significa = herda da classe pai 
    required super.status,
    required super.classId,
    required super.memberId,
    required super.className,
    required super.memberName, 
    required super.memberBelt,
    required super.professorId,
    required super.requestedAt,
    required super.memberNickname,
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
      className: map['className'],
      memberName: map['memberName'],
      memberNickname: map ['memberNickname'],
      rejectionReason: map['rejectionReason'],
      changeReason: map['changeReason'],
      requestedAt: map['requestedAt'].toDate(),
      //converte uma data que veio do Firebase do tipo Timestamp para o tipo DateTime do Dart.
      updatedAt: map['updatedAt']?.toDate(),
      memberBelt: map['memberBelt'],
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
      'className': className,
      'memberName': memberName,
      'memberNickname': memberNickname,
      'memberBelt': memberBelt

    };
  }
}

