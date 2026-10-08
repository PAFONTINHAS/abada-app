import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/location/domain/entities/location_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_request_entry_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/usecases/get_classes_for_location_usecase.dart';
import 'package:sistema_abada_capoeira/features/location/domain/usecases/get_nearby_locations_stream_usecase.dart';

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

  List<LocationEntity> _locations = [];
  List<LocationEntity> get locations => _locations;

  List<ClassEntity> _classesForLocation = [];
  List<ClassEntity> get classesForLocation => _classesForLocation;

  ClassRequestEntryEntity? _classRequestEntryEntity;
  ClassRequestEntryEntity? get classRequestEntryEntity => _classRequestEntryEntity;

  Stream<List<LocationEntity>>? _nearbyLocationsStream;
  Stream<List<LocationEntity>>? get nearbyLocationsStream => _nearbyLocationsStream;

  StreamSubscription<List<LocationEntity>>? _locationStreamSubscription;
  StreamSubscription<List<LocationEntity>>? get locationStreamSubscription => _locationStreamSubscription;

  StreamSubscription<List<ClassEntity>>? _classesForLocationSubscription;
  StreamSubscription<List<ClassEntity>>? get clasessForLocationSubscription => _classesForLocationSubscription;

  TextEditingController locationIdController = TextEditingController();
  TextEditingController professorIdController = TextEditingController();
  TextEditingController classNameController = TextEditingController();

  Stream<List<ClassEntity>>? _classesStream;
  Stream<List<ClassEntity>>? get classesStream => _classesStream;

  bool _isLoadingLocations = false;
  bool get isLoadingLocations => _isLoadingLocations;
  
  bool _isLoadingClasses = false;
  bool get isLoadingClasses => _isLoadingClasses;

  void setLocationIdController (String value){

    locationIdController.text = value;

    notifyListeners();
    
  }

  void setProfessorIdController(String value){
    professorIdController.text = value;

    notifyListeners();
  }

  void setClassNameController(String value){

    classNameController.text = value;

    notifyListeners();
  }

  void removeClassForLocation(String classEntityId){

    List<ClassEntity> currentList = _classesForLocation;

    currentList.removeWhere((entity) => entity.classId == classEntityId);

    _classesForLocation = List.from(currentList);

    notifyListeners();
  }

  void reset() {
    _locationStreamSubscription?.cancel();      
    _classesForLocationSubscription?.cancel();  
    _locationStreamSubscription = null;
    _classesForLocationSubscription = null;
    _locations = [];
    _classesForLocation = [];
    _searchRadiusKm = 10;
    _selectedLocationId = null;
    _nearbyLocationsStream = null;
    _classesStream = null;
    _isLoadingLocations = false;
    _isLoadingClasses = false;
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
      
      _nearbyLocationsStream = await _getNearbyLocationsStreamUsecase.call(_searchRadiusKm.toDouble());

      await listenToNearbyLocations();

    } catch (_) {

      LoggingService.displayInfo("Error getting nearby locations");

      _nearbyLocationsStream = null;
    }

  }

  Future<void> listenToNearbyLocations() async{

    _locationStreamSubscription?.cancel();

    if(_nearbyLocationsStream == null) return;

    _locationStreamSubscription = _nearbyLocationsStream!.listen((fetchedLocations){

      LoggingService.displayInfo("Locations found: ${fetchedLocations.length}");

      _locations = fetchedLocations;

      _isLoadingLocations = false;

      notifyListeners();
    });
  }

  void buildClassRequestEntry() {

    _classRequestEntryEntity = null;

    notifyListeners();

    _classRequestEntryEntity = ClassRequestEntryEntity(
      classId: locationIdController.text,
      classUnit: classNameController.text,
      professorId: professorIdController.text,
    );

    notifyListeners();
  }

  void updateRadius(int newRadius) {
    _searchRadiusKm = newRadius;
    initNearbyLocations(radius: newRadius);
  }

  /// Seleciona uma academia e carrega as turmas ativas dela
  void selectLocation(String locationId) {
    if (_selectedLocationId == locationId) return;

    _isLoadingClasses = true;
    _selectedLocationId = locationId;

    notifyListeners();

    _classesForLocationSubscription?.cancel();

    _classesStream = _getClassesForLocationUsecase.call(locationId);

    if(_classesStream == null){
      _isLoadingClasses = false;
      notifyListeners();
      return;
    }

    _classesForLocationSubscription = _classesStream!.listen((classes){
      _classesForLocation = classes;
      _isLoadingClasses = false;
      notifyListeners();
    });

  }

  void clearSelectedLocation() {
    _selectedLocationId = null;
    _classesStream = null;
    notifyListeners();
  }
}