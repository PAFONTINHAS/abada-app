import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sistema_abada_capoeira/core/providers/class_providers.dart';
import 'package:sistema_abada_capoeira/features/location/presentation/controllers/create_location_controller.dart';
import 'package:sistema_abada_capoeira/features/location/presentation/controllers/student_class_selection_controller.dart';
import 'package:sistema_abada_capoeira/features/location/data/datasources/location_remote_datasource.dart';
import 'package:sistema_abada_capoeira/features/location/data/datasources/location_remote_datasource_impl.dart';
import 'package:sistema_abada_capoeira/features/location/data/repository/location_repository_impl.dart';
import 'package:sistema_abada_capoeira/features/location/domain/repository/location_repository.dart';
import 'package:sistema_abada_capoeira/features/location/domain/usecases/get_nearby_locations_stream_usecase.dart';
import 'package:sistema_abada_capoeira/features/location/domain/usecases/save_class_location_usecase.dart';

class LocationProviders {

  LocationProviders._();

  static final LocationRemoteDatasource locationRemoteDatasource = LocationRemoteDatasourceImpl();

  static final LocationRepository locationRepository = LocationRepositoryImpl(locationRemoteDatasource);

  static final SaveClassLocationUsecase saveClassLocationUsecase = SaveClassLocationUsecase(locationRepository);

  static final GetNearbyLocationsStreamUsecase getNearbyLocationsStreamUsecase = GetNearbyLocationsStreamUsecase(locationRepository);

  static final List<SingleChildWidget> providers = [

    ChangeNotifierProvider(create: (_) => CreateLocationController(saveClassLocationUsecase)),
    ChangeNotifierProvider(
      create: (_) => StudentClassSelectionController(
        ClassProviders.getClassesForLocationUsecase,
        getNearbyLocationsStreamUsecase,
      ),
    )

  ];


}