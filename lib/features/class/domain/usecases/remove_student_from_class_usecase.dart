import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/class/domain/repository/class_repository.dart';

class RemoveStudentFromClassUsecase {
  final ClassRepository _classRepository;

  RemoveStudentFromClassUsecase(this._classRepository);

  Future<Either<Failure, void>> call(String studentId, String classId) {
    return _classRepository.removeStudentFromClass(studentId, classId);
  }
}
