import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/services/location_service/location_service.dart';
import 'package:sistema_abada_capoeira/core/services/location_service/place_suggestion.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';
import 'package:sistema_abada_capoeira/features/class/domain/usecases/get_classes_for_location_usecase.dart';
import 'package:sistema_abada_capoeira/features/class/domain/usecases/get_nearby_locations_stream_usecase.dart';
import 'package:sistema_abada_capoeira/features/class/domain/usecases/save_class_location_usecase.dart';


enum LocationFormState{ initial, loading, success, error }
class CreateLocationController extends ChangeNotifier{

  SaveClassLocationUsecase _saveClassLocationUsecase;

  LocationService locationService = LocationService();

  CreateLocationController(
    this._saveClassLocationUsecase,
  );

  LocationFormState _state = LocationFormState.initial;
  LocationFormState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<PlaceSuggestion> _suggestions = [];
  List<PlaceSuggestion> get suggestions => _suggestions;

  PlaceSuggestion? _selectedSuggestion;
  PlaceSuggestion? get selectedSuggestion => _selectedSuggestion;

  String? _selectedLocationId;
  String? get selectedLocationId => _selectedLocationId; 

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  Timer? _debounce;

  

  void onSearchChanged(String query){

    if(_debounce?.isActive ?? false) _debounce!.cancel();

    if(query.trim().length < 3){

      _suggestions = [];
      _isSearching = false;
      notifyListeners();
      return;
    }

    _isSearching = true;

    notifyListeners();

    _debounce = Timer(const Duration(milliseconds: 1000), () async{
      _suggestions = await locationService.searchAddress(query);

      _isSearching = false;

      notifyListeners();
    });
  }

  void selectSuggestion(PlaceSuggestion suggestion){

    _selectedSuggestion = suggestion;
    _suggestions = [];
    notifyListeners();
  }


  void clearSelection(){
    _selectedSuggestion = null;
    notifyListeners();
  }

  Future<bool> saveLocation({
    required String name,
    required String userId,
  }) async{

    if(_selectedSuggestion == null){

      _errorMessage = "Selecion um endereço da lista";
      notifyListeners();
      return false;
    }

    _state = LocationFormState.loading;
    _errorMessage = null;
    notifyListeners();


    final result = await _saveClassLocationUsecase.call(
      name: name,
      address: _selectedSuggestion!.description,
      latitude: _selectedSuggestion!.latitude,
      longitude: _selectedSuggestion!.longitude,
      userId: userId,
    );

    return result.fold((failure){
      _state = LocationFormState.error;
      _errorMessage = failure.message;
      return false;
    }, (locationId){

      _selectedSuggestion = null;
      _state = LocationFormState.success;
      _selectedLocationId = locationId;
      notifyListeners();
      return true;
    });
  }
}