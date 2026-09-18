import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_login_params.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/usecases/login_user_usecase.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';

class LoginFormController extends ChangeNotifier {
  final LoginUserUsecase _loginUserUsecase;

  LoginFormController(this._loginUserUsecase);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isInactiveAccount = false;
  bool get isInactiveAccount => _isInactiveAccount;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    emailController.dispose();
    passwordController.dispose();
  }

  UserLoginParams _buildUserLoginParamsEntity() {
    return UserLoginParams(
      email: emailController.text,
      password: passwordController.text,
    );
  }

  void cleanControllers() {
    emailController.clear();
    passwordController.clear();
  }

  Future<bool> loginUser() async {
    _isLoading = true;
    _errorMessage = null;
    _isInactiveAccount = false;

    notifyListeners();

    final UserLoginParams userLoginParams = _buildUserLoginParamsEntity();

    final result = await _loginUserUsecase.call(userLoginParams);

    final success = result.fold((failure) {
      _errorMessage = failure.message;
      _isInactiveAccount = failure is InactiveAccountFailure;
      return false;
    }, (_) => true);

    _isLoading = false;

    notifyListeners();

    cleanControllers();

    return success;
  }
}
