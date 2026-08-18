import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/info_card.dart';

const Color _primaryPurple = Color(0xFF7C5CBF);
const Color _lightPurple = Color(0xFFF1EDFB);

/// Widget da Corda atual e historico
class CurrentBeltCard extends StatelessWidget {
  final String currentBeltName;
  final VoidCallback onViewHistory;

  const CurrentBeltCard({
    super.key,
    required this.currentBeltName,
    required this.onViewHistory,
  });

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      children: [
        Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: _lightPurple,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.emoji_events_outlined,
                color: _primaryPurple,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Corda Atual',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentBeltName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: onViewHistory,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.history, size: 14, color: _primaryPurple),
                        SizedBox(width: 6),
                        Text(
                          'Histórico de graduações',
                          style: TextStyle(
                            color: _primaryPurple,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black45),
          ],
        ),
      ],
    );
  }
}
