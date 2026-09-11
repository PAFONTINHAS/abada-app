import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_role.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/usecases/logout_user_usecase.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/models/auth_status.dart';

class AuthController extends ChangeNotifier{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LogoutUserUsecase _logoutUserUsecase;

  AuthController(this._logoutUserUsecase){

    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  User? _user;
  User? get user => _user; 

  UserRole _userRole = UserRole.unknown;
  UserRole get userRole => _userRole;

  AuthStatus _status = AuthStatus.initializing;
  AuthStatus get status => _status;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isRegistering = false;
  bool get isRegistering => _isRegistering;

  bool _isSigningIn = false;
  bool get isSigningIn => _isSigningIn;


  void _onAuthStateChanged(User? changedUser){

    _user = changedUser;

    if(_user == null){

      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return;
    }


    if((!_isRegistering || !_isSigningIn) && _userRole != UserRole.unknown){

      LoggingService.displayInfo('''

        UserRole: $_userRole
        IsRegistering: $_isRegistering
        IsSigningIn: $_isSigningIn

      ''');

      _status = AuthStatus.authenticated;
  
      notifyListeners();
    }


  }

  Future<bool> logoutUser() async{

    final result = await _logoutUserUsecase.call();

    return result.fold(

      (failure) => false,
      (_) => true
    );
  }

  void setAuthStatus(AuthStatus status){

    _status = status;
    notifyListeners();
  }

  void setUserRole(UserRole userRole){
    _userRole = userRole;
    notifyListeners();
  }

  void setAuthenticatedUser({required UserRole role}){

    _userRole = role;
    _status = AuthStatus.authenticated;

    notifyListeners();
  }
}