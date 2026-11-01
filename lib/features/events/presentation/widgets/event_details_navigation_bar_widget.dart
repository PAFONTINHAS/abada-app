import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_decision_parameters.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_details_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_requests_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/models/event_details_modals.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/acess_profile.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';

class EventDetailsNavigationBarWidget extends StatelessWidget {
  const EventDetailsNavigationBarWidget({
    super.key,
    required this.controller,
    required this.requestId,
  });

  final EventDetailsController controller;
  final String requestId;

  Future<bool> _decide(
    BuildContext context, {
    required bool reject,
    required String reason,
  }) async {
    final profileController = context.read<ProfileController>();
    final requestsController = context.read<EventRequestsController>();

    // Verifica se o perfil está carregado.
    if (profileController.status != ProfileLoadStatus.loaded) {
      return false;
    }

    final profile = profileController.userProfile;

    // Somente coordenadores podem analisar solicitações.
    if (profile.role != UserRole.coordinator) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Somente coordenadores podem analisar eventos.'),
        ),
      );

      return false;
    }

    final eventId = controller.eventEntity?.eventId ?? '';
    if (!controller.canDecide(requestId, eventId)) {
      return false;
    }

    // Dados necessários para registrar a decisão.
    final params = EventRequestDecisionParameters(
      requestId: requestId,
      eventId: eventId,
      coordinatorId: profile.uid,
      coordinatorName: profile.displayName,
      reason: reason,
    );

    // Executa a recusa ou a solicitação de alterações.
    final bool success = reject
        ? await requestsController.reject(params)
        : await requestsController.requestChanges(params);

    // Evita usar o contexto se o widget foi desmontado.
    if (!context.mounted) {
      return success;
    }

    if (success) {
      await controller.getEventById(eventId, requestId: requestId);
      if (!context.mounted) return success;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            reject
                ? 'Solicitação recusada com sucesso.'
                : 'Alterações solicitadas com sucesso.',
          ),
        ),
      );

      await requestsController.getPendingRequests();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            requestsController.actionError ??
                'Não foi possível concluir a solicitação.',
          ),
        ),
      );
    }

    // O modal utiliza este retorno para decidir se deve fechar.
    return success;
  }

  @override
  Widget build(BuildContext context) {
    final profileController = context.watch<ProfileController>();
    final requestsController = context.watch<EventRequestsController>();

    if (profileController.status != ProfileLoadStatus.loaded ||
        profileController.userProfile.role != UserRole.coordinator) {
      return const SizedBox.shrink();
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Recusar solicitação
            Expanded(
              child: OutlinedButton(
                onPressed: requestsController.isProcessing
                    ? null
                    : () => EventDetailsModals.showReasonModal(
                        context: context,
                        title: 'Recusar Solicitação',
                        labelText: 'Informe o motivo da recusa...',
                        buttonColor: Colors.red,
                        onSubmit: (reason) =>
                            _decide(context, reject: true, reason: reason),
                      ),
                child: const Text('Recusar'),
              ),
            ),

            const SizedBox(width: 8),

            // Solicitar alterações
            Expanded(
              child: OutlinedButton(
                onPressed: requestsController.isProcessing
                    ? null
                    : () => EventDetailsModals.showReasonModal(
                        context: context,
                        title: 'Solicitar Alterações',
                        labelText: 'Descreva as correções...',
                        buttonColor: Colors.orange,
                        onSubmit: (reason) =>
                            _decide(context, reject: false, reason: reason),
                      ),
                child: const Text('Ajustes'),
              ),
            ),

            const SizedBox(width: 8),

            // Aprovar solicitação
            Expanded(
              child: ElevatedButton(
                onPressed: requestsController.isProcessing
                    ? null
                    : () => EventDetailsModals.showConfirmApproveDialog(
                        context,
                        controller,
                      ),
                child: const Text('Aprovar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
