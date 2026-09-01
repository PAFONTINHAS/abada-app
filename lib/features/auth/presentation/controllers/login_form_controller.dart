import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_entity.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_login_params.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_role.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/extensions/user_role_extension.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/usecases/login_user_usecase.dart';

class LoginFormController extends ChangeNotifier{

  final LoginUserUsecase _loginUserUsecase;

  LoginFormController(this._loginUserUsecase);


  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  UserRole? _authenticatedUserRole;
  UserRole? get authenticatedUserRole => _authenticatedUserRole;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose(){
    super.dispose();

    emailController.dispose();
    passwordController.dispose();
  }


  UserLoginParams _buildUserLoginParamsEntity(){

    return UserLoginParams(
      email: emailController.text,
      password: passwordController.text,
    );

  } 

  void cleanControllers(){
    emailController.clear();
    passwordController.clear();
  }

  Future<bool> loginUser() async{

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    final UserLoginParams userLoginParams = _buildUserLoginParamsEntity();

    final result = await _loginUserUsecase.call(userLoginParams);

    final success = result.fold(
      (failure) {
        _errorMessage = failure.message;
        return false;
      }, (userEntity){

        final UserRole userRole = UserRoleExtension.getFromString(userEntity.userRole);

        if(userRole != UserRole.unknown){

          _authenticatedUserRole = userRole;
        }

        return true;
      }
    );

    _isLoading = false;

    notifyListeners();

    cleanControllers();
    
    return success;
  }
}