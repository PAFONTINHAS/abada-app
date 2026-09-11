import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/user_profile_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/repository/profile_repository.dart';

class UploadProfilePhotoUsecase {

  ProfileRepository profileRepository;


  UploadProfilePhotoUsecase(this.profileRepository);


  Future<Either<Failure, void>> call(UserProfileEntity userProfileEntity, Uint8List imageBytes) async{

    final updatedUser = userProfileEntity.copyWith(photoUrl: )


    return await profileRepository.uploadProfilePhoto(imageBytes);

  }


}