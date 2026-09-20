import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:sistema_abada_capoeira/core/utils/date_formatter.dart';
import 'package:sistema_abada_capoeira/core/utils/message_handler.dart';
import 'package:sistema_abada_capoeira/core/utils/tusca_protocol_generator.dart';
import 'package:sistema_abada_capoeira/core/utils/tusca_receipt_generator.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/user_profile_entity.dart';

class TuscaReceiptDialog extends StatelessWidget {
  final UserProfileEntity profile;

  const TuscaReceiptDialog({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final protocol = profile.tusca.protocol;
    final shortId = TuscaProtocolGenerator.generateShortId(profile);
    final validUntil = DateFormatter.formatDDMMYYYY(profile.tusca.validUntil);
    
    final validatorName = profile.tusca.validatorName ?? 'Diretoria Abadá Capoeira';
    final rawValidatorId = profile.tusca.validatorId ?? '00000';
    final validatorShortId = rawValidatorId.length > 5 ? rawValidatorId.substring(0, 5).toUpperCase() : rawValidatorId;

    Future<void> sharePdf() async{

      // MessageHandler
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.info, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Gerando PDF...",
                  style: const TextStyle(color: Colors.white),
                ),
              ),

              SizedBox(width: 12),
              const CircularProgressIndicator(),
            ],
          ),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
        ),
      );


      final pdfBytes = await TuscaReceiptGenerator.generateReceipt(profile);
      
      // O sharePdf abre a gaveta nativa do celular (iOS/Android) 
      // permitindo salvar nos arquivos ou mandar direto no WhatsApp
      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: 'comprovante_tusca_$shortId.pdf',
      );

      if(!context.mounted) return;

      ScaffoldMessenger.of(context).removeCurrentSnackBar();
    }

    return AlertDialog(
      title: const Text(
        'Comprovante TUSCA',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Declaro que ${profile.fullName}, também conhecido como ${profile.nickname} está regular com a TUSCA",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          Text('Professor(a): ${profile.fullName} - ${profile.nickname}', style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text('Protocolo: $protocol', style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text('Validade: Até $validUntil', style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text('Atestado por: $validatorName', style: const TextStyle(fontWeight: FontWeight.w500)),
          Text('Auth: $validatorShortId', style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton.icon(
          onPressed: () async => await sharePdf(), 
          
          // {
          //   // Gera o PDF em memória
          //   final pdfBytes = await TuscaReceiptGenerator.generateReceipt(profile);
            
          //   // O sharePdf abre a gaveta nativa do celular (iOS/Android) 
          //   // permitindo salvar nos arquivos ou mandar direto no WhatsApp
          //   await Printing.sharePdf(
          //     bytes: pdfBytes,
          //     filename: 'comprovante_tusca_$shortId.pdf',
          //   );
            
          // },
          icon: const Icon(Icons.download),
          label: const Text('Baixar PDF'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );


  }

}

