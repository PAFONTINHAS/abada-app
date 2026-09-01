import 'package:sistema_abada_capoeira/features/profile/domain/repository/profile_repository.dart';

class RequestBeltNicknameChangeUseCase {
  final ProfileRepository repository;

  RequestBeltNicknameChangeUseCase(this.repository);

  Future<void> execute({
    required String originalBelt,
    required String originalNickname,
    String? newBelt,
    String? newNickname,
  }) async {
    if (newBelt == null && newNickname == null) {
      throw ArgumentError('Informe uma nova corda ou apelido.');
    }

    await repository.requestChangeBeltNick(
      originalBelt: originalBelt,
      originalNickname: originalNickname,
      newBelt: newBelt,
      newNickname: newNickname,
    );
  }
}
