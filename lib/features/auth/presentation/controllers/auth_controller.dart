import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/models/auth_status.dart';

class AuthController extends ChangeNotifier{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthController(){

    _auth.authStateChanges().listen(_onAuthStateChanged);
  }
  
  User? _user;
  User? get user => _user; 

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


    if(!_isRegistering || !_isSigningIn){

      _status = AuthStatus.initializing;
    }

    notifyListeners();
  }

  void setAuthStatus(AuthStatus status){

    _status = status;
    notifyListeners();
  }
}