import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/standard_event_usecase.dart';

class GetEventsUsecase extends StandardEventUsecase{

  GetEventsUsecase(super.eventRepository);

  Future<Either<Failure, List<EventEntity>>> call() async{
    return await eventRepository.getEvents();
  }
}