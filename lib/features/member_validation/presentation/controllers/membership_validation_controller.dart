import 'package:flutter/foundation.dart';

import '../../domain/entities/membership_request.dart';
import '../../domain/usecases/approve_membership_request_usecase.dart';
import '../../domain/usecases/get_professor_membership_requests_usecase.dart';
import '../../domain/usecases/reject_membership_request_usecase.dart';
import '../../domain/usecases/request_membership_changes_usecase.dart';

class MembershipValidationController extends ChangeNotifier {
  final GetProfessorMembershipRequestsUseCase getProfessorRequestsUsecase;
  final ApproveMembershipRequestUseCase approveMembershipRequestUsecase;
  final RequestMembershipChangesUseCase requestMembershipChangesUsecase;
  final RejectMembershipRequestUsecase rejectMembershipRequestUsecase;

  MembershipValidationController({
    required this.getProfessorRequestsUsecase,
    required this.approveMembershipRequestUsecase,
    required this.requestMembershipChangesUsecase,
    required this.rejectMembershipRequestUsecase,
  });

  List<MembershipRequest> requests = [];

  bool isLoading = false;
  String? errorMessage;
  String? actionErrorMessage;

  bool _disposed = false;
  int _loadVersion = 0;
  final Set<String> _processingRequestIds = {};

  bool isProcessingRequest(String requestId) {
    return _processingRequestIds.contains(requestId);
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  Future<void> loadRequests(String professorId) async {
    final version = ++_loadVersion;

    isLoading = true;
    errorMessage = null;
    _notify();

    try {
      final result = await getProfessorRequestsUsecase.call(professorId);

      if (_disposed || version != _loadVersion) return;

      result.fold(
        (failure) => errorMessage = failure.message,
        (loadedRequests) => requests = loadedRequests,
      );
    } catch (error) {
      if (!_disposed && version == _loadVersion) {
        errorMessage = 'Não foi possível carregar as solicitações.';
        debugPrint('Error loading requests: $error');
      }
    } finally {
      if (!_disposed && version == _loadVersion) {
        isLoading = false;
        _notify();
      }
    }
  }

  Future<bool> _executeAction(
    String requestId,
    Future<bool> Function() action,
  ) async {
    if (_disposed) {
      return false;
    }
    if (_processingRequestIds.contains(requestId)) {
      actionErrorMessage = 'Esta solicitação já está sendo processada.';
      _notify();
      return false;
    }

    _processingRequestIds.add(requestId);
    actionErrorMessage = null;
    _notify();

    try {
      return await action();
    } catch (error) {
      actionErrorMessage = 'Não foi possível concluir a operação.';
      debugPrint('Error processing request: $error');
      return false;
    } finally {
      _processingRequestIds.remove(requestId);
      _notify();
    }
  }

  Future<bool> approve(MembershipRequest request, String professorId) {
    return _executeAction(request.id, () async {
      final result = await approveMembershipRequestUsecase.call(request);

      return result.fold((failure) {
        actionErrorMessage = failure.message;
        return false;
      }, (_) => true);
    });
  }

  Future<bool> requestChanges(
    String requestId,
    String changeReason,
    String professorId,
  ) {
    return _executeAction(requestId, () async {
      final result = await requestMembershipChangesUsecase.call(
        requestId,
        changeReason,
      );

      return result.fold((failure) {
        actionErrorMessage = failure.message;
        return false;
      }, (_) => true);
    });
  }

  Future<bool> reject(
    String requestId,
    String rejectReason,
    String professorId,
  ) {
    return _executeAction(requestId, () async {
      final result = await rejectMembershipRequestUsecase.call(
        requestId,
        rejectReason,
      );

      return result.fold((failure) {
        actionErrorMessage = failure.message;
        return false;
      }, (_) => true);
    });
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
