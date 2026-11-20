import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/router/route_controller.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_type.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/acess_profile.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/models/event_details_modals.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_decision_parameters.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_details_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_requests_controller.dart';

class EventDetailsRevisionBottomWidget extends StatelessWidget {
  const EventDetailsRevisionBottomWidget({super.key, required this.controller, required this.request});

  final EventRequestEntity request;
  final EventDetailsController controller;

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

    // Dados necessários para registrar a decisão.
    final params = EventRequestDecisionParameters(
      reason: reason,
      eventId: eventId,
      requestId: request.requestId,
      coordinatorId: profile.uid,
      coordinatorName: profile.displayName,
    );

    // Executa a recusa ou a solicitação de alterações.
    final bool success = reject
        ? await requestsController.reject(params)
        : await requestsController.requestChanges(params);

    // Evita usar o contexto se o widget foi desmontado.
    if (!context.mounted) return success;

    if (success) {
      // await controller.getEventById(eventId, requestId: requestId);
      // if (!context.mounted) return success;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            reject
                ? 'Solicitação recusada com sucesso.'
                : 'Alterações solicitadas com sucesso.',
          ),
        ),
      );

      RouteController.redirectToPendingEventRequestsPage(context: context);

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
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  
                  if (requestsController.isProcessing) return;

                  EventDetailsModals.showReasonModal(
                    context: context,
                    title: 'Recusar Solicitação',
                    labelText: 'Informe o motivo da recusa...',
                    buttonColor: Colors.red,
                    onSubmit: (reason) => _decide(context, reject: true, reason: reason),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: ColorConstants.whiteColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Recusar",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            SizedBox(width: 10),

            if(request.requestType.isCreationRequest)
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (requestsController.isProcessing) return;

                    EventDetailsModals.showReasonModal(
                      context: context,
                      title: 'Solicitar Alterações',
                      labelText: 'Descreva as correções...',
                      buttonColor: Colors.orange,
                      onSubmit: (reason) => _decide(context, reject: false, reason: reason),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade700,
                    foregroundColor: ColorConstants.whiteColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Ajustes",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

            SizedBox(width: 10),


            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  if (requestsController.isProcessing) return;
                  EventDetailsModals.showConfirmApproveDialog(
                    context,
                    controller,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: ColorConstants.whiteColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Aprovar",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
