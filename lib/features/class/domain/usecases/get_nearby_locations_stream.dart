import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sistema_abada_capoeira/features/class/domain/usecases/standard_class_usecase.dart';

class GetNearbyLocationsStream extends StandardClassUsecase{

  GetNearbyLocationsStream(super.classRepository);


  Future<Stream<List<DocumentSnapshot>>> getNearbyLocationsStream(
    double radiusInKm,
  ) async {
    return await classRepository.getNearbyLocationsStream(radiusInKm);
  }

}