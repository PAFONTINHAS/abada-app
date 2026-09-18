import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/shared/buttons/custom_text_button.dart';

class DeclarationUploadCardWidget extends StatelessWidget {
  final VoidCallback onSelectFile;

  const DeclarationUploadCardWidget({super.key, required this.onSelectFile});

  static const Color purple = Color(0xFF5936C8);
  static const Color secondaryText = Color(0xFF7C7890);
  static const Color lightPurple = Color(0xFFF5F1FF);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6E1F2)),
      ),
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              color: lightPurple,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.upload_file_outlined,
              color: purple,
              size: 30,
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'Enviar declaração preenchida',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF252334),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Selecione a declaração preenchida e assinada '
            'para enviar à TUSCA.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, height: 1.4, color: secondaryText),
          ),

          const SizedBox(height: 18),

          CustomTextButton(
            text: 'Selecionar arquivo',
            color: purple,
            textColor: Colors.white,
            alignment: Alignment.center,
            onPressed: onSelectFile,
          ),
        ],
      ),
    );
  }
}
