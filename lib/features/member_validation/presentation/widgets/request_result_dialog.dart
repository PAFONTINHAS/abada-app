import 'package:flutter/material.dart';

enum RequestResultType {
  approved,
  changesRequested,
  rejected,
}

class RequestResultDialog extends StatelessWidget {
  final RequestResultType type;

  const RequestResultDialog({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final resultData = _getResultData();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: resultData.backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                resultData.icon,
                color: resultData.iconColor,
                size: 32,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              resultData.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              resultData.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Entendi'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _RequestResultData _getResultData() {
    switch (type) {
      case RequestResultType.approved:
        return _RequestResultData(
          icon: Icons.check,
          iconColor: Colors.green,
          backgroundColor: Colors.green.shade50,
          title: 'Solicitação aprovada',
          message:
              'O vínculo do aluno foi aprovado com sucesso.',
        );

      case RequestResultType.changesRequested:
        return _RequestResultData(
          icon: Icons.edit_outlined,
          iconColor: Colors.orange,
          backgroundColor: Colors.orange.shade50,
          title: 'Correções solicitadas',
          message:
              'As correções foram enviadas ao aluno. A solicitação ficará aguardando as atualizações.',
        );

      case RequestResultType.rejected:
        return _RequestResultData(
          icon: Icons.close,
          iconColor: Colors.red,
          backgroundColor: Colors.red.shade50,
          title: 'Solicitação rejeitada',
          message:
              'A solicitação foi rejeitada e o motivo informado será comunicado ao aluno.',
        );
    }
  }
}

class _RequestResultData {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String title;
  final String message;

  const _RequestResultData({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.title,
    required this.message,
  });
}