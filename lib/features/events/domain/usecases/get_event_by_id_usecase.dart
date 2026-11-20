import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/standard_event_usecase.dart';

class GetEventByIdUsecase extends StandardEventUsecase{

  GetEventByIdUsecase(super.eventRepository);

  Future<Either<Failure, EventEntity>> call(String eventId) async{
    return await eventRepository.getEventById(eventId);
  }

}