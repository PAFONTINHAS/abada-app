import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_login_params.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/usecases/login_user_usecase.dart';

class LoginFormController extends ChangeNotifier{

  final LoginUserUsecase _loginUserUsecase;

  LoginFormController(this._loginUserUsecase);


  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


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
      }, (userEntity) => true
    );

    _isLoading = false;

    notifyListeners();

    cleanControllers();
    
    return success;
  }
}