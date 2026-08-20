import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/shared/buttons/custom_text_button.dart';

class FormButtonWidget extends StatelessWidget {
  const FormButtonWidget({
    super.key,
    required this.text,
    required this.height,
    required this.buttonCollor,
    required this.onPressed,
    this.prefixImagePath,
    this.textColor,
    this.alignment
  });

  final double height;
  final String text;
  final VoidCallback onPressed;
  final Color buttonCollor;
  final Alignment? alignment;
  final String? prefixImagePath;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: CustomTextButton(
        text: text,
        onPressed: onPressed,
        color: buttonCollor,
        textColor: textColor ?? Colors.white,
        alignment: alignment ?? Alignment.center,
        fontSize: 17,
        prefixImagePath: prefixImagePath,
      ),
    );
  }
}
