import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FeeExemptionSentPage extends StatelessWidget {
  final String feeExemptionId;

  const FeeExemptionSentPage({super.key, required this.feeExemptionId});

  static const Color purple = Color(0xFF5936C8);
  static const Color secondaryText = Color(0xFF7C7890);
  static const Color lightPurple = Color(0xFFF7F4FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const Spacer(),

              const Icon(Icons.send_rounded, color: purple, size: 80),

              const SizedBox(height: 24),

              const Text(
                'Solicitação enviada',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: purple,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Sua solicitação foi enviada para a TUSCA.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: secondaryText),
              ),

              const SizedBox(height: 28),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: lightPurple,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'O que acontece agora?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: purple,
                      ),
                    ),

                    SizedBox(height: 16),

                    Text(
                      'A TUSCA irá analisar sua solicitação.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: secondaryText,
                      ),
                    ),

                    SizedBox(height: 12),

                    Text(
                      'Você receberá uma notificação quando houver uma decisão.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: secondaryText,
                      ),
                    ),

                    SizedBox(height: 12),

                    Text(
                      'Após a aprovação, o comprovante ficará disponível no seu perfil.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: secondaryText,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: () {
                    context.push('/fee-exemption/details/$feeExemptionId');
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: purple,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Ver solicitação',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  context.go('/profile');
                },
                child: const Text(
                  'Voltar para o perfil',
                  style: TextStyle(color: purple, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
