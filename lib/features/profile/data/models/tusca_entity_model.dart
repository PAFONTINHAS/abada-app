import 'package:sistema_abada_capoeira/features/profile/domain/entities/tusca_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/tusca_status.dart';

class TuscaEntityModel extends TuscaEntity{

  const TuscaEntityModel({
    super.protocol,
    super.validUntil,
    super.validatorId,
    super.validatorName,
    required super.tuscaStatus,
  });

  factory TuscaEntityModel.fromSnapshotData(Map<String, dynamic> data){

    final TuscaStatus status = TuscaStatusExtension.fromString(data['status']);
    final validUntil = data['validUntil']?.toDate();

    return TuscaEntityModel(
      tuscaStatus: status,
      validUntil: validUntil,
      protocol: data['protocol'],
      validatorId: data['validatorId'],
      validatorName: data['validatorName'],
    );
  }

}