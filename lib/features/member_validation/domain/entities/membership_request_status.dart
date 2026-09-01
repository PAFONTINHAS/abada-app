//status do membro

enum MembershipRequestStatus {
  requested, //cadastrado e pendente
  changesRequested, //prof pediu ajustes
  updated, //membro corrigiu
  approved, //prof aprovou
  rejected, //prof recusou
}