import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/user_events_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/standard_event_usecase.dart';

class GetUserEventsUsecase extends StandardEventUsecase{

  GetUserEventsUsecase(super.eventRepository);

  Future<Either<Failure, UserEventsEntity>> call(String userId) async{

    List<EventEntity> events = [];
    List<EventRequestEntity> eventRequests = [];

    Failure? errorOnRequest;

    final eventsFuture = await Future.wait([
        eventRepository.getEventsByUserId(userId),
        eventRepository.getPendingEventsRequestsByUserId(userId)
      ]
    );

    eventsFuture.first.fold(
      (failure) => errorOnRequest = failure,
      (fetchedEvents) => events = List.from(fetchedEvents),
    );

    eventsFuture.last.fold(
      (failure) => errorOnRequest = failure,
      (fetchedEventsRequests) => eventRequests = List.from(fetchedEventsRequests),
    );

    if(errorOnRequest != null) return Left(errorOnRequest!);

    UserEventsEntity userEventsEntity = UserEventsEntity(
      eventRequests: eventRequests,
      events: events,
    );

    return Right(userEventsEntity);
  }
}