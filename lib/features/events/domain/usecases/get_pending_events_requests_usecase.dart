import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/standard_event_usecase.dart';

class GetPendingEventsRequestsUsecase extends StandardEventUsecase{

  GetPendingEventsRequestsUsecase(super.eventRepository);

  Future<Either<Failure, List<EventRequestEntity>>> call() async{

    return await eventRepository.getPendingEventsRequests();
  }

}