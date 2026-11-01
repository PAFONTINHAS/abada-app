import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_type.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_products_item.dart';
import 'package:sistema_abada_capoeira/features/events/domain/repository/event_repository.dart';

EventEntity eventFixture() => EventEntity(
  eventId: 'event-1',
  eventName: 'Evento original',
  eventLocation: 'Curitiba',
  eventType: EventType.COMPETITION,
  eventValue: '120.00',
  products: [EventProductItem(product: 'Camisa', price: 20, mandatory: true)],
  finishedEvent: false,
  eventCreatorId: 'teacher',
  eventCreatorNickname: 'Professor',
  eventInitDate: DateTime(2027, 1, 1),
  eventEndingDate: DateTime(2027, 1, 2),
  eventDescription: 'Descrição',
  eventImagePath: 'https://example.test/old.jpg',
);

class RepositoryStub implements EventRepository {
  Either<Failure, void> result = const Right(null);
  GenericRequestStatus nextStatus = GenericRequestStatus.requested;
  EventEntity persisted = eventFixture();
  EventEntity? submitted;
  String? submittedRequestId;
  bool failRead = false;
  bool failUpload = false;
  int uploads = 0;
  final deletedImages = <String>[];
  String uploadedUrl = 'https://example.test/events/rf22-new.jpeg';

  @override
  Future<Either<Failure, EventEntity>> getEventById(
    String eventId, {
    bool serverOnly = false,
  }) async =>
      failRead ? const Left(NetworkFailure('offline')) : Right(persisted);

  @override
  Future<Either<Failure, GenericRequestStatus>> resubmitEventRequest(
    String requestId,
    EventEntity event,
  ) async {
    submittedRequestId = requestId;
    submitted = event;
    return result.map((_) => nextStatus);
  }

  @override
  Future<Either<Failure, String>> uploadEventImage(
    File eventImage,
    String fileName,
  ) async {
    uploads++;
    return failUpload
        ? const Left(NetworkFailure('offline'))
        : Right(uploadedUrl);
  }

  @override
  Future<Either<Failure, void>> deleteEventImage(String imageUrl) async {
    deletedImages.add(imageUrl);
    return const Right(null);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
