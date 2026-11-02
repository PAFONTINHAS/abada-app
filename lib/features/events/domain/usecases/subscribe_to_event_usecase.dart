import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_subscription_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/standard_event_usecase.dart';

class SubscribeToEventUsecase extends StandardEventUsecase{

  SubscribeToEventUsecase(super.eventRepository);


  Future<Either<Failure, EventSubscriptionEntity>> call(EventSubscriptionEntity subscription) async{

    return await eventRepository.subscribeToEvent(subscription);
  }
}