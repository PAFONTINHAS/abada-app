import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/standard_event_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/events_and_user_subscriptions.dart';

class GetEventsUsecase extends StandardEventUsecase{

  GetEventsUsecase(super.eventRepository);

  Future<Either<Failure, EventsAndUserSubscriptions>> call(String userId) async{

    return await eventRepository.getEventsAndSubscriptions(userId);
  }
}