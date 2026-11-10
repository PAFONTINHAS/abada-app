//classe de política de domínio, responsável por definir regras de status das solicitações de eventos
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';

class EventRequestPolicy {
  //verifica se a mudança de status é permitida
  static const editingTransitions = {
    GenericRequestStatus.requested: GenericRequestStatus.requested,
    GenericRequestStatus.changesRequested: GenericRequestStatus.updated,
  };

  static bool canEdit(GenericRequestStatus status) => editingTransitions.containsKey(status); //prof pode editar a solicitacao?

  static bool canDecide(GenericRequestStatus status) => //coord pode analisar a solicitacao?
      status == GenericRequestStatus.requested ||
      status == GenericRequestStatus.updated;

  static const editableFields = {
    'eventName',
    'eventLocation',
    'eventDescription',
    'eventType',
    'eventValue',
    'eventImagePath',
    'products',
    'selectedClassId',
    'selectedMembersId',
  };
}
