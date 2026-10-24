import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/utils/region_mapper.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/get_events_usecase.dart';

class EventsController extends ChangeNotifier{

  final GetEventsUsecase _getEventsUsecase;

  String _selectedRegion = "Todas";
  String get selectedRegion => _selectedRegion;

  int _selectedViewIndex = 0;
  int get selectedViewIndex => _selectedViewIndex;

  // String _searchBar = "";
  // String get searchBar => _searchBar;

  TextEditingController searchBar = TextEditingController();

  List<EventEntity> get filteredEvents {
    
    final currentFilteredEvents =  _events.where((event) {
      // Filtra por região usando o mapeador baseado no state da entidade
      final eventRegion = RegionMapper.getRegionFromState(event.state);
      final matchesRegion = _selectedRegion == 'Todas' || eventRegion == _selectedRegion;

      // Filtra por busca (texto)
      final search = eventSearchController.text.toLowerCase();
      final matchesSearch =
          search.isEmpty ||
          event.eventName.toLowerCase().contains(search) ||
          event.city.toLowerCase().contains(search);

      return matchesRegion && matchesSearch;
    }).toList();

    currentFilteredEvents.sort(
      (a, b) => a.eventInitDate.compareTo(b.eventInitDate),
    );


    return currentFilteredEvents;
  }

  EventsController(this._getEventsUsecase);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<EventEntity> _events = [];
  List<EventEntity> get events => _events;

  TextEditingController eventSearchController = TextEditingController();

  void setSelectedRegion(String region){
    _selectedRegion = region;
    notifyListeners();
  }

  void setSelectedViewIndex(int index){
    _selectedViewIndex = index;
    notifyListeners();
  }


  void setEventSearchController(String search){

    eventSearchController.text = search;

    notifyListeners();
  }

  Future<bool> getEvents() async{

    _isLoading = true;
    notifyListeners();

    final result = await _getEventsUsecase.call();

    final bool success = result.fold((failure){
      _errorMessage = failure.message;
      return false;
    }, (fetchedEvents){
      _events = List.from(fetchedEvents);

      return true;
    });

    _isLoading = false;
    notifyListeners();

    return success;
  }

}