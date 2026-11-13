import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/repository/class_repository.dart';
import 'package:sistema_abada_capoeira/features/class/domain/validators/create_class_usecase_validator.dart';

class CreateClassUsecase {

  final ClassRepository classRepository;

  CreateClassUsecase(this.classRepository);

  Future<Either<Failure, ClassEntity>> call(ClassEntity classEntity) async{
    
    final String? validator = CreateClassUsecaseValidator.validate(classEntity);

    if(validator != null) return Left(ValidationFailure(validator));

    return await classRepository.createClass(classEntity);

  }

}