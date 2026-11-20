import 'package:sistema_abada_capoeira/features/profile/domain/entities/tusca_status.dart';

class TuscaEntity {

  final TuscaStatus status;
  final DateTime? validUntil;
  final String? validatorName;
  final String? validatorId;
  final String? protocol;

  const TuscaEntity({
    this.protocol,
    this.validUntil,
    this.validatorId,
    this.validatorName,
    required this.status,
  });

  Map<String, dynamic> toMap(){

    return {
      'protocol': protocol,
      'status': status.name,
      'validUntil': validUntil,
      'validatorId': validatorId,
      'validatorName': validatorName,
    };
  }
}


extension TuscaEntityExtension on TuscaEntity{

  bool get isRegularTusca{

    final isValidStatus = status.isValidTusca;

    final isValidDate = validUntil?.isAfter(DateTime.now()) ?? false;

    return isValidStatus && isValidDate;
  }

  bool get isApplicableTusca{

    return !status.notApplicable; 

  }
}