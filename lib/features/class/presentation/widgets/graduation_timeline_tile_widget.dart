import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/utils/date_controller.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/graduation_history_entity.dart';

class GraduationTimelineTile extends StatelessWidget {
  final GraduationHistoryEntity historyItem;
  final bool isLast;

  const GraduationTimelineTile({
    super.key,
    required this.historyItem,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {

    final formattedEventDate = DateController.formatEventDate(historyItem.eventInitDate, historyItem.eventEndingDate);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Indicator Column
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: ColorConstants.indigoLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: ColorConstants.indigoColor,
                  size: 18,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: ColorConstants.borderColor,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),

          // Content Card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ColorConstants.surfaceColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: ColorConstants.borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nome do Evento / Batizado / Troca de Cordas
                    Text(
                      historyItem.eventName,
                      style: const TextStyle(
                        color: ColorConstants.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Datas do Evento
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: ColorConstants.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          formattedEventDate,
                          style: const TextStyle(
                            color: ColorConstants.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Transição de Corda (Anterior -> Nova)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ColorConstants.indigoLight.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          // Corda Anterior
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Anterior",
                                  style: TextStyle(
                                    color: ColorConstants.textSecondary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  historyItem.previousBelt,
                                  style: const TextStyle(
                                    color: ColorConstants.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: ColorConstants.indigoColor,
                            size: 20,
                          ),

                          // Nova Corda Conquistada
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  "Promoção",
                                  style: TextStyle(
                                    color: ColorConstants.indigoColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  historyItem.updatedBelt,
                                  style: const TextStyle(
                                    color: ColorConstants.indigoDark,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}