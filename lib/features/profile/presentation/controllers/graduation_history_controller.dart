import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/graduation_history_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/usecases/get_graduation_history_usecase.dart';

class GraduationHistoryController extends ChangeNotifier{

  final GetGraduationHistoryUsecase _getGraduationHistoryUsecase;

  GraduationHistoryController(this._getGraduationHistoryUsecase);

  bool _isLoading = false;
  bool get isLoading  => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<GraduationHistoryEntity> _graduationHistory = [];
  List<GraduationHistoryEntity> get graduationHistory => _graduationHistory;

  Future<bool> getHistory(String userId) async{

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _getGraduationHistoryUsecase.call(userId);

    final success = result.fold((failure){
      _errorMessage = failure.message;
      return false;   
    }, (history){

      _graduationHistory = List<GraduationHistoryEntity>.from(history);
      return true;
    });


    _graduationHistory.sort((a, b) => b.eventEndingDate.compareTo(a.eventEndingDate));

    _isLoading = false;
    notifyListeners();
    return success;
  }

}