import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sistema_abada_capoeira/features/class/data/datasources/class_remote_datasource.dart';
import 'package:sistema_abada_capoeira/features/class/data/datasources/class_remote_datasource_impl.dart';
import 'package:sistema_abada_capoeira/features/class/data/repository/class_repository_impl.dart';
import 'package:sistema_abada_capoeira/features/class/domain/repository/class_repository.dart';
import 'package:sistema_abada_capoeira/features/class/domain/usecases/get_attended_classes_usecase.dart';
import 'package:sistema_abada_capoeira/features/class/domain/usecases/get_lectured_classes_usecase.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/class_controller.dart';

class ClassProviders {

  ClassProviders._();


  static final ClassRemoteDatasource classRemoteDatasource = ClassRemoteDatasourceImpl();
  static final ClassRepository classRepository = ClassRepositoryImpl(classRemoteDatasource);

  static final GetAttendedClassesUsecase getAttendedClassesUsecase = GetAttendedClassesUsecase(classRepository);
  static final GetLecturedClassesUsecase getLecturedClassesUsecase = GetLecturedClassesUsecase(classRepository);

  static final List<SingleChildWidget> providers = [

    ChangeNotifierProvider(create: (_) => ClassController(getAttendedClassesUsecase, getLecturedClassesUsecase)),

  ];

}