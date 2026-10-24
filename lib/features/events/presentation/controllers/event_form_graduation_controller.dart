import 'package:flutter/foundation.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';

class EventFormGraduationController extends ChangeNotifier{

  bool get isGraduationPhaseComplete{
    return _selectedMemberIds.isNotEmpty;
  }

  ClassEntity? _selectedClass;
  ClassEntity? get selectedClass => _selectedClass;

  // Armazena os IDs dos alunos selecionados para graduação
  final Set<String> _selectedMemberIds = {};
  Set<String> get selectedMemberIds => _selectedMemberIds;

  void selectClass(ClassEntity? classEntity) {
    _selectedClass = classEntity;
    _selectedMemberIds.clear(); // Limpa a seleção ao trocar de turma
    notifyListeners();
  }

  void toggleMemberSelection(String memberId) {
    if (_selectedMemberIds.contains(memberId)) {
      _selectedMemberIds.remove(memberId);
    } else {
      _selectedMemberIds.add(memberId);
    }
    notifyListeners();
  }

  void toggleSelectAllMembers() {
    if (_selectedClass == null) return;
    
    if (_selectedMemberIds.length == _selectedClass!.members.length) {
      _selectedMemberIds.clear();
    } else {
      _selectedMemberIds.addAll(_selectedClass!.members.map((m) => m.studentId));
    }
    notifyListeners();
  }
    



}