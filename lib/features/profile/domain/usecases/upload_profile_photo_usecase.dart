import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/user_profile_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/repository/profile_repository.dart';

class UploadProfilePhotoUsecase {

  ProfileRepository profileRepository;


  UploadProfilePhotoUsecase(this.profileRepository);


  Future<Either<Failure, UserProfileEntity>> call(UserProfileEntity userProfileEntity, Uint8List imageBytes) async{

    final uploadProfilePhoto = await profileRepository.uploadProfilePhoto(userProfileEntity.id, imageBytes);
    
    return uploadProfilePhoto.fold((failure) => Left(failure), (updatedPhotoUrl) async{
      
      final updatedUser = userProfileEntity.copyWith(photoUrl: updatedPhotoUrl);

      return await profileRepository.updateUserEntity(updatedUser);

    });
  }

}