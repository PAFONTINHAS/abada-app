import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';

class RequestDecisionDetailsDialogWidget extends StatelessWidget {
  const RequestDecisionDetailsDialogWidget({
    super.key,
    required this.request,
  });

  final EventRequestEntity request;

  @override
  Widget build(BuildContext context) {
    String title = "Detalhes da Solicitação";
    String? reason;

    if (request.status == GenericRequestStatus.changesRequested) {
      title = "Solicitação de Alterações";
      reason = request.changeReason;
    } else if (request.status == GenericRequestStatus.rejected) {
      title = "Motivo da Recusa";
      reason = request.rejectionReason;
    }

    final reasonText = reason != null && reason.trim().isNotEmpty
        ? reason.trim()
        : "Sem observações detalhadas.";

    final coordinatorName =
        request.decidedByName != null &&
            request.decidedByName!.trim().isNotEmpty
        ? request.decidedByName!.trim()
        : "Não informado";

    final decisionDate = request.decidedAt;

    final formattedDecisionDate = decisionDate != null
        ? "${decisionDate.day.toString().padLeft(2, '0')}/"
              "${decisionDate.month.toString().padLeft(2, '0')}/"
              "${decisionDate.year} às "
              "${decisionDate.hour.toString().padLeft(2, '0')}:"
              "${decisionDate.minute.toString().padLeft(2, '0')}"
        : null;

    return AlertDialog(
      backgroundColor: ColorConstants.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: ColorConstants.textPrimary,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Observação dos avaliadores:",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: ColorConstants.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColorConstants.backgroundColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: ColorConstants.borderColor,
                ),
              ),
              child: Text(
                reasonText,
                style: const TextStyle(
                  color: ColorConstants.textPrimary,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Responsável pela decisão:",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: ColorConstants.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 18,
                  color: ColorConstants.textSecondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    coordinatorName,
                    style: const TextStyle(
                      color: ColorConstants.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            if (formattedDecisionDate != null) ...[
              const SizedBox(height: 16),
              const Text(
                "Data da decisão:",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.access_time_outlined,
                    size: 18,
                    color: ColorConstants.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      formattedDecisionDate,
                      style: const TextStyle(
                        color: ColorConstants.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Fechar"),
        ),
      ],
    );
  }
}
