import 'package:sistema_abada_capoeira/core/utils/validators.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_login_params.dart';

class LoginUserUsecaseValidator {

  LoginUserUsecaseValidator._();


  static String? validate(UserLoginParams userLoginParams){

    if(userLoginParams.email.isEmpty) return 'Campo de email não pode ser vazio';

    if(userLoginParams.password.isEmpty) return 'Campo de senha não pode ser vazia';

    if(!isValidEmail(userLoginParams.email)) return  'Digite um email válido';

    return null;
  }

}