import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/repository/profile_repository.dart';

class UploadProfilePhotoUsecase {

  ProfileRepository profileRepository;


  UploadProfilePhotoUsecase(this.profileRepository);


  Future<Either<Failure, void>> call(Uint8List imageBytes) async{


    return await profileRepository.uploadProfilePhoto(imageBytes);

  }


}