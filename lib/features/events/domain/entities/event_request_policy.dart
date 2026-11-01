import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';

/// RF22 transitions. Unknown and terminal states are deliberately excluded.
class EventRequestPolicy {
  static const editingTransitions = {
    GenericRequestStatus.requested: GenericRequestStatus.requested,
    GenericRequestStatus.changesRequested: GenericRequestStatus.updated,
  };

  static bool canEdit(GenericRequestStatus status) =>
      editingTransitions.containsKey(status);

  static bool canDecide(GenericRequestStatus status) =>
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
