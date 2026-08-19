import 'package:flutter/material.dart';

class HomePageController extends ChangeNotifier{

  bool _isLogin = true;
  bool get isLogin => _isLogin;


  void setIsLogin(bool value){

    _isLogin = value;

    notifyListeners();

  }


}