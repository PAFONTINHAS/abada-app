import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_update_parameters.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/standard_event_usecase.dart';

class ApproveEventCancelationRequestUsecase extends StandardEventUsecase{

  ApproveEventCancelationRequestUsecase(super.eventRepository);


  Future<Either<Failure, void>> call(EventRequestEntity request) async{

    final approveRequest = await eventRepository.approveRequest(
      GenericRequestUpdateParameters(requestId: request.requestId),
    );

    return approveRequest.fold((failure) => Left(failure), (_) async{
      return await eventRepository.cancelEvent(request.eventId);
    });
  }

  
}