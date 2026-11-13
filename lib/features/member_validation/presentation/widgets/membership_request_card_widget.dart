import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/utils/date_formatter.dart';
import 'package:sistema_abada_capoeira/features/member_validation/domain/entities/membership_request_status.dart';
import 'package:sistema_abada_capoeira/features/member_validation/presentation/widgets/action_button_widget.dart';
import 'package:sistema_abada_capoeira/shared/clickable/clickable_widget.dart';

import '../../domain/entities/membership_request.dart';

class MembershipRequestCardWidget extends StatelessWidget {
  final MembershipRequest request;
  final VoidCallback onApprove;
  final VoidCallback onRequestChanges;
  final VoidCallback onReject;
  final VoidCallback? onDetails;

  const MembershipRequestCardWidget({
    super.key,
    required this.request,
    required this.onApprove,
    required this.onRequestChanges,
    required this.onReject,
    this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    final String memberName = "${request.memberName} - ${request.memberNickname}";

    return ClickableWidget(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      onTap: onDetails ?? () {},
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho: Avatar e Informações (Inspirado no MemberEntryRequestCardWidget)
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.amber,
                  ),
                  // Se tiver a foto no request futuramente, pode trocar o Icon pelo Image.asset ou Image.network
                  child: Image.asset(
                    "assets/images/capoeira_member_profile_picture.png",
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        memberName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Agrupamento de informações para reduzir o ruído visual
                      Text(
                        "Corda ${request.memberBelt} • ${request.className}",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Status: ${request.status.portugueseName}",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Solicitado em ${DateFormatter.formatDDMMYYYYHM(request.requestedAt)}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onDetails != null)
                  Icon(
                    Icons.chevron_right,
                    size: 28,
                    color: Colors.grey.shade400,
                  ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Rodapé: Botões de Ação isolados
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ActionButtonWidget(
                  icon: Icons.close,
                  iconColor: Colors.red,
                  backgroundColor: Colors.red.shade50,
                  onPressed: onReject,
                ),
                const SizedBox(width: 12),
                ActionButtonWidget(
                  icon: Icons.edit_outlined,
                  iconColor: Colors.orange,
                  backgroundColor: Colors.orange.shade50,
                  onPressed: onRequestChanges,
                ),
                const SizedBox(width: 12),
                ActionButtonWidget(
                  icon: Icons.check,
                  iconColor: Colors.deepPurple,
                  backgroundColor: Colors.deepPurple.shade50,
                  onPressed: onApprove,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  
}