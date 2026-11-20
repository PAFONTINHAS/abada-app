import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/data/datasources/event_cancellation_remote_datasource.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/domain/entities/event_cancellation_request_entity.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/domain/repository/event_cancellation_repository.dart';

class EventCancellationRepositoryImpl implements EventCancellationRepository {
  const EventCancellationRepositoryImpl(this.datasource);

  final EventCancellationRemoteDatasource datasource;

  @override
  Future<Either<Failure, bool>> checkIfRequestAlreadyExists(String eventId) async{
    return datasource.checkIfRequestAlreadyExists(eventId);
  }


  @override
  Future<Either<Failure, EventCancellationRequestEntity>> requestCancellation(EventCancellationRequestEntity request) async {
    return await datasource.requestCancellation(request);
  }

  @override
  Future<Either<Failure, List<EventCancellationRequestEntity>>> getPendingRequests() async {
    return await datasource.getPendingRequests();
  }

  @override
  Future<Either<Failure, EventCancellationRequestEntity>> reviewCancellation({
    required EventCancellationRequestEntity request,
    required bool approve,
    required String reviewerId,
  }) async {
    return await datasource.reviewCancellation(
      request: request,
      approve: approve,
      reviewerId: reviewerId,
    );
  }
}
