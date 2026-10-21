import 'package:flutter/material.dart';

class RequestDialogWidget extends StatelessWidget {
  final Widget child;

  const RequestDialogWidget({super.key, required this.child});
  static const Color approvalColor = Color(0xFF4CAF50);
  static const Color rejectionColor = Color(0xFFEF4444);
  static const Color correctionColor = Color(0xFFF59E0B);
  // Visual reutilizável para ícones de ações.
  static Widget actionIcon({required IconData icon, required Color color}) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 32),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        decoration: BoxDecoration(
          color: theme.dialogTheme.backgroundColor ?? theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(28),
        ),
        child: SingleChildScrollView(child: child),
      ),
    );
  }
}
