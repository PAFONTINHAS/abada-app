import 'package:flutter/material.dart';

class DeactivateAccountDialog extends StatefulWidget {
  final Future<bool> Function() onConfirm;

  const DeactivateAccountDialog({super.key, required this.onConfirm});

  @override
  State<DeactivateAccountDialog> createState() =>
      _DeactivateAccountDialogState();
}

class _DeactivateAccountDialogState extends State<DeactivateAccountDialog> {
  bool isSubmitting = false;
  String? errorMessage;

  Future<void> _confirmDeactivation() async {
    setState(() {
      isSubmitting = true;
      errorMessage = null;
    });

    final success = await widget.onConfirm();
    if (!mounted) return;

    if (!success) {
      setState(() {
        isSubmitting = false;
        errorMessage = 'Não foi possível desativar sua conta.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Desativar minha conta?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Seus dados não serão apagados. Sua conta será desativada e você sairá do aplicativo.',
          ),
          if (errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(errorMessage!, style: const TextStyle(color: Colors.red)),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: isSubmitting ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: isSubmitting ? null : _confirmDeactivation,
          icon: isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.person_off_outlined),
          label: const Text('Desativar conta'),
          style: FilledButton.styleFrom(backgroundColor: Colors.red),
        ),
      ],
    );
  }
}
