import 'package:sistema_abada_capoeira/features/profile/domain/repository/profile_repository.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/validators/info_profile_validator.dart';

class UpdateProfileInfoUseCase {
  final ProfileRepository repository;

  UpdateProfileInfoUseCase(this.repository);

  Future<void> execute({
    required String fullName,
    required String email,
    required String phoneNumber,
  }) async {
    if (!InfoProfileValidator.isValidFullName(fullName)) {
      throw ArgumentError('Invalid full name');
    }
    if (!InfoProfileValidator.isValidEmail(email)) {
      throw ArgumentError('Invalid email');
    }
    if (!InfoProfileValidator.isValidPhoneNumber(phoneNumber)) {
      throw ArgumentError('Invalid phone number');
    }

    await repository.updatePersonalInfo(
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
    );
  }
}
