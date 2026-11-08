import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/standard_event_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_subscription_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/validators/subscribe_minor_to_event_usecase_validator.dart';

class SubscribeMinorToEventUsecase extends StandardEventUsecase{

  SubscribeMinorToEventUsecase(super.eventRepository);

  Future<Either<Failure, EventSubscriptionEntity>> call(EventSubscriptionEntity subscription) async{

    final validator = SubscribeMinorToEventUsecaseValidator.validate(subscription);

    if(validator != null) return Left(ValidationFailure(validator));

    return await eventRepository.subscribeToEvent(subscription);
  }
}