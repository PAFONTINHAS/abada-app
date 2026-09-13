import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/shared/clickable/clickable_widget.dart';

class MemberEntryRequestCardWidget extends StatelessWidget {
  const MemberEntryRequestCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ClickableWidget(

        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Avatar do membro circular com clip
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber,
                ),
                child: Image.asset(
                  "assets/images/capoeira_member_profile_picture.png",
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 14),

              // Dados da Solicitação
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Pedro Henrique",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Unidade Centro",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Solicitado em 26/06/2026, 10:30",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(Icons.chevron_right, size: 28, color: Colors.grey.shade400),
            ],
          ),
        ),
    );
  }
}
