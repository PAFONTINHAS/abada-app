import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_details_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/models/event_details_modals.dart';

class EventDetailsNavigationBarWidget extends StatelessWidget {
  const EventDetailsNavigationBarWidget({super.key, required this.controller});

  final EventDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ColorConstants.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Botão Rejeitar
            Expanded(
              child: OutlinedButton(
                onPressed: () => EventDetailsModals.showReasonModal(
                  context: context,
                  title: "Recusar Solicitação",
                  labelText: "Escreva o motivo da recusa...",
                  buttonColor: Colors.red.shade700,
                  onSubmit: (reason) async {
                    context.pop();
                    // FAÇA OS COISOS AQUI
                  },
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade700,
                  side: BorderSide(color: Colors.red.shade400),
                  padding: const EdgeInsets.symmetric(vertical: 12),
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
            const SizedBox(width: 8),

            // Botão Pedir Alterações
            Expanded(
              child: OutlinedButton(
                onPressed: () => EventDetailsModals.showReasonModal(
                  context: context,
                  title: "Solicitar Ajustes",
                  labelText: "Descreva as alterações necessárias...",
                  buttonColor: Colors.orange.shade800,
                  onSubmit: (reason) async {
                    // FAÇA OS COISOS AQUI
                    context.pop();
                  },
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.orange.shade800,
                  side: BorderSide(color: Colors.orange.shade400),
                  padding: const EdgeInsets.symmetric(vertical: 12),
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
            const SizedBox(width: 8),

            // Botão Aprovar
            Expanded(
              child: ElevatedButton(
                onPressed: () => EventDetailsModals.showConfirmApproveDialog(
                  context,
                  controller,
                ),
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
