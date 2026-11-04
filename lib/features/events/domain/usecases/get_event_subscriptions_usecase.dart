import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/standard_event_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_subscription_entity.dart';

class GetEventSubscriptionsUsecase extends StandardEventUsecase{

  GetEventSubscriptionsUsecase(super.eventRepository);

  Future<Either<Failure, List<EventSubscriptionEntity>>> call(String userId) async{

    return eventRepository.getEventSubscriptions(userId);
  }
}