import 'package:flutter/material.dart';

import 'package:sistema_abada_capoeira/shared/buttons/custom_text_button.dart';

class SubmitFeeExemptionButtonWidget extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const SubmitFeeExemptionButtonWidget({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  static const Color purple = Color(0xFF5936C8);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 52,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return CustomTextButton(
      text: 'Enviar Solicitação',
      color: purple,
      textColor: Colors.white,
      alignment: Alignment.center,
      onPressed: onPressed,
    );
  }
}
