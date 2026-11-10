import 'package:flutter/foundation.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';

class EventGraduationController extends ChangeNotifier {
  ClassEntity? _selectedClass;
  ClassEntity? get selectedClass => _selectedClass;



  // IDs dos alunos selecionados para graduação.
  final Set<String> _selectedMemberIds = {};

  Set<String> get selectedMemberIds => Set.unmodifiable(_selectedMemberIds);

  // Match the existing graduation validator before proceeding.
  bool get isGraduationPhaseComplete =>
      _selectedClass != null && _selectedMemberIds.isNotEmpty;

  void cleanController(){
    _selectedClass = null;
    _selectedMemberIds.clear();
  }
  
  // Seleciona uma turma e limpa os alunos da turma anterior.
  void selectClass(ClassEntity? classEntity) {
    _selectedClass = classEntity;
    _selectedMemberIds.clear();
    notifyListeners();
  }

  // RF22 - Restaura turma e participantes do evento existente.
  void loadGraduationSelection({
    required ClassEntity? selectedClass,
    required Set<String>? selectedMemberIds,
  }) {
    _selectedClass = selectedClass;

    _selectedMemberIds
      ..clear()
      ..addAll(selectedMemberIds ?? <String>{});

    notifyListeners();
  }

  // Adiciona ou remove um aluno da seleção.
  void toggleMemberSelection(String memberId) {
    if (_selectedMemberIds.contains(memberId)) {
      _selectedMemberIds.remove(memberId);
    } else {
      _selectedMemberIds.add(memberId);
    }

    notifyListeners();
  }

  // Seleciona ou desmarca todos os alunos da turma.
  void toggleSelectAllMembers() {
    if (_selectedClass == null) return;

    final classMemberIds = _selectedClass!.members
        .map((member) => member.studentId)
        .toSet();

    if (classMemberIds.isEmpty) return;

    if (_selectedMemberIds.containsAll(classMemberIds)) {
      _selectedMemberIds.removeAll(classMemberIds);
    } else {
      _selectedMemberIds.addAll(classMemberIds);
    }

    notifyListeners();
  }

  // Limpa os dados ao iniciar um novo formulário.
  void reset() {
    _selectedClass = null;
    _selectedMemberIds.clear();
    notifyListeners();
  }
}
