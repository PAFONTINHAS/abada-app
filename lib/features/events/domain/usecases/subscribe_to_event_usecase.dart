import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/standard_event_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_subscription_entity.dart';

class SubscribeToEventUsecase extends StandardEventUsecase{

  SubscribeToEventUsecase(super.eventRepository);


  Future<Either<Failure, EventSubscriptionEntity>> call(EventSubscriptionEntity subscription) async{

    LoggingService.displayInfo("Validando disponibilidade para a inscrição do usuário ${subscription.userId} ao evento ${subscription.eventId}");
    
    final validateEventSubscriptionAvailability = await eventRepository
        .validateEventSubscriptionAvailability(
          subscription.userId,
          subscription.eventId,
        );

    return validateEventSubscriptionAvailability.fold((failure) => Left(failure), (fetchedSubscription) async{

      if(fetchedSubscription != null){

        LoggingService.displayInfo("Inscrição já foi realizada pelo usuário. Retornando sem processar nova inscrição");
      }

      if(fetchedSubscription != null) return Right(fetchedSubscription); 

      LoggingService.displayInfo("Inscrição ainda não realizada. Processando inscrição");


      return await eventRepository.subscribeToEvent(subscription);
    });
  }
}