class FeeExemptionDocumentEntity {
  final String id;
  final String requestId;

  final String fileName;
  final String storagePath;

  final int version;

  final String uploadedBy;
  final DateTime uploadedAt;

  const FeeExemptionDocumentEntity({
    required this.id,
    required this.requestId,
    required this.fileName,
    required this.storagePath,
    required this.version,
    required this.uploadedBy,
    required this.uploadedAt,
  });
}
