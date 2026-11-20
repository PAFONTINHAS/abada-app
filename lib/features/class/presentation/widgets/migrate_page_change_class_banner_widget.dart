import 'package:flutter/material.dart';

class MigratePageChangeClassBannerWidget extends StatelessWidget {
  const MigratePageChangeClassBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade400, width: 1),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: Colors.amber.shade900,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Solicite aqui a transferência para a sua nova turma no sistema ABADÁ.",
              style: TextStyle(
                color: Colors.amber.shade900,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
