class GraduationHistoryEntity {

  final String previousBelt;
  final String updatedBelt;
  final String eventName;
  final DateTime updatedAt;
  final DateTime eventInitDate;
  final DateTime eventEndingDate;

  const GraduationHistoryEntity({
    required this.updatedAt,
    required this.eventName,
    required this.updatedBelt,
    required this.previousBelt,
    required this.eventInitDate,
    required this.eventEndingDate,
  });

}