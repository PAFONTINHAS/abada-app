import '../../domain/entities/fee_exemption_document_entity.dart';

//representa cada pdf real no firebase
class FeeExemptionDocumentModel extends FeeExemptionDocumentEntity {
  const FeeExemptionDocumentModel({
    required super.id,
    required super.requestId,
    required super.fileName,
    required super.storagePath,
    required super.version,
    required super.uploadedBy,
    required super.uploadedAt,
  });

  factory FeeExemptionDocumentModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return FeeExemptionDocumentModel(
      id: id,
      requestId: map['requestId'],
      fileName: map['fileName'],
      storagePath: map['storagePath'],
      version: map['version'],
      uploadedBy: map['uploadedBy'],
      uploadedAt: map['uploadedAt'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'fileName': fileName,
      'storagePath': storagePath,
      'version': version,
      'uploadedBy': uploadedBy,
      'uploadedAt': uploadedAt,
    };
  }
}
