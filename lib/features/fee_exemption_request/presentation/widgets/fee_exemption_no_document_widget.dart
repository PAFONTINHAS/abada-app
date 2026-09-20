import 'package:flutter/material.dart';

class NoDocumentWidget extends StatelessWidget {
  const NoDocumentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F4FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: Color(0xFF5936C8)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Nenhum documento foi encontrado para esta solicitação.',
              style: TextStyle(fontSize: 13, color: Color(0xFF7C7890)),
            ),
          ),
        ],
      ),
    );
  }
}