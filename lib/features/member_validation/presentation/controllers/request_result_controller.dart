import 'package:flutter/material.dart';

import '../models/request_result_data.dart';
import '../models/request_result_type.dart';

class RequestResultController {
  RequestResultData getResultData(
    RequestResultType type,
  ) {
    switch (type) {
      case RequestResultType.approved:
        return RequestResultData(
          icon: Icons.check,
          iconColor: Colors.green,
          backgroundColor: Colors.green.shade50,
          title: 'Solicitação aprovada',
          message:
              'O vínculo do aluno foi aprovado com sucesso.',
        );

      case RequestResultType.changesRequested:
        return RequestResultData(
          icon: Icons.edit_outlined,
          iconColor: Colors.orange,
          backgroundColor: Colors.orange.shade50,
          title: 'Correções solicitadas',
          message:
              'As correções foram enviadas ao aluno. A solicitação ficará aguardando as atualizações.',
        );

      case RequestResultType.rejected:
        return RequestResultData(
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