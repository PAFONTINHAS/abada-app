import 'package:sistema_abada_capoeira/features/events/data/datasources/event_remote_datasource.dart';
import 'package:sistema_abada_capoeira/features/events/domain/repository/event_repository.dart';

class EventRepositoryImpl implements EventRepository{

  EventRemoteDatasource remoteDatasource;

  EventRepositoryImpl(this.remoteDatasource);


}