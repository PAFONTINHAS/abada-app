import 'package:sistema_abada_capoeira/core/utils/validators.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_registration_params.dart';

class RegisterUserUsecaseValidator {

  RegisterUserUsecaseValidator._();


  static String? validateEmptyness(UserRegistrationParams userRegistrationParams){

    if(userRegistrationParams.email.isEmpty) return 'Campo de email não pode ser vazio';
    if(userRegistrationParams.password.isEmpty) return 'Campo de senha não pode ser vazio';
    if(userRegistrationParams.nickname.isEmpty) return 'Campo de apelido não pode ser vazio';
    if(userRegistrationParams.fullName.isEmpty) return 'Campo de nome não pode ser vazio';
    if(userRegistrationParams.confirmPassword.isEmpty) return 'Campo de senha não pode ser vazio';
    if(userRegistrationParams.professor.isEmpty) return 'Campo de professor não pode ser vazio';
    if(userRegistrationParams.rope.isEmpty) return 'Campo de corda não pode ser vazio';
    if(userRegistrationParams.phone.isEmpty) return 'Campo de telefone não pode ser vazio';

    if(!isValidEmail(userRegistrationParams.email)) return "Digite um email válido";

    return null;
  }

  static String? validatePasswords(UserRegistrationParams userRegistrationParams){

    if(userRegistrationParams.password != userRegistrationParams.confirmPassword) return "Senhas não coincidem";

    if(!isStrongPassword(userRegistrationParams.password)) {
      return "Senha fraca! Deve conter pelo menos 8 caracteres, incluindo maiúsculas, minúsculas, números e símbolos.";
    }

    return null;
  }
}