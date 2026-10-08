import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sistema_abada_capoeira/features/class/domain/repository/class_repository.dart';
import 'package:sistema_abada_capoeira/features/class/domain/usecases/update_class_usecase.dart';
import 'package:sistema_abada_capoeira/features/class/domain/usecases/create_class_usecase.dart';
import 'package:sistema_abada_capoeira/features/class/data/repository/class_repository_impl.dart';
import 'package:sistema_abada_capoeira/features/class/data/datasources/class_remote_datasource/class_remote_datasource.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/class_controller.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/class_migration_controller.dart';
import 'package:sistema_abada_capoeira/features/location/domain/usecases/save_class_location_usecase.dart';
import 'package:sistema_abada_capoeira/features/class/domain/usecases/get_attended_classes_usecase.dart';
import 'package:sistema_abada_capoeira/features/class/domain/usecases/get_lectured_classes_usecase.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/schedule_controller.dart';
import 'package:sistema_abada_capoeira/features/class/data/datasources/class_remote_datasource/class_remote_datasource_impl.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/class_form_controller.dart';
import 'package:sistema_abada_capoeira/features/class/domain/usecases/get_classes_for_location_usecase.dart';

class ClassProviders {

  ClassProviders._();

  static final ClassRemoteDatasource classRemoteDatasource = ClassRemoteDatasourceImpl();
  static final ClassRepository classRepository = ClassRepositoryImpl(classRemoteDatasource);

  static final CreateClassUsecase createClassUsecase = CreateClassUsecase(classRepository);
  static final UpdateClassUsecase updateClassUsecase = UpdateClassUsecase(classRepository);
  static final GetAttendedClassesUsecase getAttendedClassesUsecase = GetAttendedClassesUsecase(classRepository);
  static final GetLecturedClassesUsecase getLecturedClassesUsecase = GetLecturedClassesUsecase(classRepository);
  static final GetClassesForLocationUsecase getClassesForLocationUsecase = GetClassesForLocationUsecase(classRepository);

  static final List<SingleChildWidget> providers = [

    ChangeNotifierProvider(
      create: (_) => ClassController(
        createClassUsecase,
        updateClassUsecase,
        getAttendedClassesUsecase,
        getLecturedClassesUsecase,
      ),
    ),
    ChangeNotifierProvider(create: (_) => ClassFormController()),
    ChangeNotifierProvider(create: (_) => ScheduleController()),
    ChangeNotifierProvider(create: (_) => ClassMigrationController())


  ];

}