import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/usecases/standard_class_usecase.dart';

class GetClassesForLocationUsecase extends StandardClassUsecase{


  GetClassesForLocationUsecase(super.classRepository);


  Stream<List<ClassEntity>> call(String locationId) {
    return classRepository.getClassesForLocation(locationId);
  }

}