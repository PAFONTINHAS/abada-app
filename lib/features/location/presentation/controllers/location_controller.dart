import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/services/location_service/user_location_entity.dart';
import 'package:sistema_abada_capoeira/features/location/domain/usecases/get_user_location_usecase.dart';

class LocationController extends ChangeNotifier{

  final GetUserLocationUsecase _getUserLocationUsecase;

  LocationController(this._getUserLocationUsecase);

  UserLocationEntity? _userLocationEntity;
  UserLocationEntity? get userLocationEntity => _userLocationEntity;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  
  Future<bool> getUserLocation() async{

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _getUserLocationUsecase.call();

    final bool success = result.fold((failure){
      _errorMessage = failure.message;
      return false;
    }, (userLocation){

      _userLocationEntity = userLocation;
      return true;
    });

    _isLoading = false;

    notifyListeners();

    return success;
  }

}