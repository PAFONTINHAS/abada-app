import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';
import 'package:sistema_abada_capoeira/features/class/domain/usecases/get_classes_for_location_usecase.dart';
import 'package:sistema_abada_capoeira/features/class/domain/usecases/get_nearby_locations_stream_usecase.dart';

class StudentClassSelectionController extends ChangeNotifier {
  final GetNearbyLocationsStreamUsecase _getNearbyLocationsStreamUsecase;
  final GetClassesForLocationUsecase _getClassesForLocationUsecase;

  StudentClassSelectionController(
    this._getClassesForLocationUsecase,
    this._getNearbyLocationsStreamUsecase,
  );

  int _searchRadiusKm = 10;
  int get searchRadiusKm => _searchRadiusKm;

  String? _selectedLocationId;
  String? get selectedLocationId => _selectedLocationId;

  Stream<List<DocumentSnapshot>>? _nearbyLocationsStream;
  Stream<List<DocumentSnapshot>>? get nearbyLocationsStream => _nearbyLocationsStream;

  Stream<QuerySnapshot>? _classesStream;
  Stream<QuerySnapshot>? get classesStream => _classesStream;

  bool _isLoadingLocations = false;
  bool get isLoadingLocations => _isLoadingLocations;

  void reset() {
    _searchRadiusKm = 10;
    _selectedLocationId = null;
    _nearbyLocationsStream = null;
    _classesStream = null;
    _isLoadingLocations = false;
    notifyListeners();
  }

  @override
  void dispose() {
    reset();
    super.dispose();
  }

  /// Inicializa o Stream de localidades próximas com base na posição GPS atual
  Future<void> initNearbyLocations({int? radius}) async {
    if (radius != null) _searchRadiusKm = radius;

    _isLoadingLocations = true;
    notifyListeners();

    try {
      
      LoggingService.displayInfo("Getting nearby locations");
      _nearbyLocationsStream = await _getNearbyLocationsStreamUsecase.call(_searchRadiusKm.toDouble());
      
      LoggingService.displayInfo("NearbyLocations: $_nearbyLocationsStream");

    } catch (_) {

      LoggingService.displayInfo("Error getting nearby locations");

      _nearbyLocationsStream = null;
    } finally {
      _isLoadingLocations = false;
      notifyListeners();
    }
  }

  void updateRadius(int newRadius) {
    _searchRadiusKm = newRadius;
    initNearbyLocations(radius: newRadius);
  }

  /// Seleciona uma academia e carrega as turmas ativas dela
  void selectLocation(String locationId) {
    if (_selectedLocationId == locationId) return;

    _selectedLocationId = locationId;
    _classesStream = _getClassesForLocationUsecase.call(locationId);
    notifyListeners();
  }

  void clearSelectedLocation() {
    _selectedLocationId = null;
    _classesStream = null;
    notifyListeners();
  }
}