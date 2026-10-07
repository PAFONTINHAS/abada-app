import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/services/location_service/location_service.dart';
import 'package:sistema_abada_capoeira/core/services/location_service/place_suggestion.dart';
import 'package:sistema_abada_capoeira/features/location/domain/entities/location_entity.dart';
import 'package:sistema_abada_capoeira/features/location/domain/usecases/save_class_location_usecase.dart';


enum LocationFormState{ initial, loading, success, error }

class CreateLocationController extends ChangeNotifier{

  final SaveClassLocationUsecase _saveClassLocationUsecase;

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

  TextEditingController _fullAddress = TextEditingController();
  TextEditingController get fullAddress => _fullAddress;

  String? _selectedLocationId;
  String? get selectedLocationId => _selectedLocationId; 

  String? _selectedLocationAddress;
  String? get selectedLocationAddress => _selectedLocationAddress;

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

    if(_selectedSuggestion != null){
      _fullAddress.text = _selectedSuggestion!.fullAddress;
    }
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

      _errorMessage = "Selecione um endereço da lista";
      notifyListeners();
      return false;
    }

    _state = LocationFormState.loading;
    _errorMessage = null;
    notifyListeners();

    final LocationEntity locationEntity = LocationEntity(
      id: '',
      name: name,
      createdBy: userId,
      address: _selectedSuggestion!.fullAddress,
      latitude: _selectedSuggestion!.latitude,
      district: _selectedSuggestion!.district,
      longitude: _selectedSuggestion!.longitude,
      osmKey:  _selectedSuggestion!.osmKey,
      createdAt: DateTime.now(),
    );

    final result = await _saveClassLocationUsecase.call(locationEntity);

    return result.fold((failure){
      _state = LocationFormState.error;
      _errorMessage = failure.message;
      return false;
    }, (location){

      _selectedSuggestion = null;
      _state = LocationFormState.success;
      _selectedLocationId = location.id;
      _selectedLocationAddress = location.address;
      notifyListeners();
      return true;
    });
  }
}