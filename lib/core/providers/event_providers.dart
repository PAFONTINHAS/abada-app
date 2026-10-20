import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sistema_abada_capoeira/features/events/domain/repository/event_repository.dart';
import 'package:sistema_abada_capoeira/features/events/data/repository/event_repository_impl.dart';
import 'package:sistema_abada_capoeira/features/events/data/datasources/event_remote_datasource.dart';
import 'package:sistema_abada_capoeira/features/events/data/datasources/event_remote_datasource_impl.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_phases_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_products_controller.dart';

class EventProviders {

  EventProviders._();

  static EventRemoteDatasource eventRemoteDatasource = EventRemoteDatasourceImpl();
  static EventRepository eventRepository = EventRepositoryImpl(eventRemoteDatasource);


  static final List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => EventFormController()),
    ChangeNotifierProvider(create: (_) => EventProductsController()),
    ChangeNotifierProvider(create: (_) => EventFormPhasesController()),
  ];
}