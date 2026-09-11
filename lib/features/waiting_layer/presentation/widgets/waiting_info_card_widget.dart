import 'package:flutter/material.dart';

class WaitingInfoCard extends StatelessWidget {
  const WaitingInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 22,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFEEEEEE),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: const Column(
        children: [
          Text(
            'Seu cadastro foi enviado e está aguardando a validação de um professor responsável.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF292929),
            ),
          ),

          SizedBox(height: 16),

          Divider(),

          SizedBox(height: 16),

          Text(
            'Assim que seu vínculo for aprovado, você terá acesso às turmas, eventos e todas as funcionalidades do aplicativo.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF292929),
            ),
          ),
        ],
      ),
    );
  }
}