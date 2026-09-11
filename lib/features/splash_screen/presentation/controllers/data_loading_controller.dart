import 'package:flutter/material.dart';

class DataLoadingController extends ChangeNotifier{

  double _progress = 0.0;
  String _progressText = "Iniciando...";

  double get progress => _progress;
  String get progressText => _progressText;

  final List<String> _loadingSteps = [
    "Inicializando serviços...",
    "Carregando metadados do aplicativo...",
    "Carregando dados do usuário...",
    "Carregando materiais e catálogo...",
    "Carregando seus ambientes...",
    "Sincronizando eventos e cultivos...",
    "Carregando plantas cultivadas...",
    "Organizando agenda de eventos...",
    "Finalizando configurações..."
  ];

  int _currentStepIndex = 0;

  void nextStep(){
    if(_currentStepIndex < _loadingSteps.length){
      _progressText = _loadingSteps[_currentStepIndex];

      _currentStepIndex++;

      _progress = _currentStepIndex / _loadingSteps.length;

      notifyListeners();
    }
  }


    


}