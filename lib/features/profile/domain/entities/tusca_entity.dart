import 'package:sistema_abada_capoeira/features/profile/domain/entities/tusca_status.dart';

class TuscaEntity {

  final TuscaStatus tuscaStatus;
  final DateTime? validUntil;
  final String? tuscaReceiptId;
  final String? validatorName;
  final String? validatorId;
  final String? protocol;

  const TuscaEntity({
    this.protocol,
    this.validUntil,
    this.validatorId,
    this.validatorName,
    this.tuscaReceiptId,
    required this.tuscaStatus,
  });

  Map<String, dynamic> toMap(){

    return {
      'protocol': protocol,
      'status': tuscaStatus,
      'validUntil': validUntil,
      'validatorId': validatorId,
      'validatorName': validatorName,
    };
  }

}