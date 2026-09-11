import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;
  final Alignment? alignment;
  final VoidCallback? onPressed;
  final double? fontSize;
  final String? prefixImagePath;


  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.fontSize,
    this.alignment = Alignment.centerLeft,
    this.prefixImagePath
  });

  @override
  Widget build(BuildContext context) {
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;

    return isIos ? _buildCupertinoButton() : _buildMaterialButton();
  }

  Widget _buildCupertinoButton() {
    return CupertinoButton(
      // Se color for null, ele age como TextButton. Se tiver cor, age como botão preenchido.
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: BorderRadius.circular(10),
      alignment: alignment ?? Alignment.center,
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          // Se não houver cor de texto definida, usa o azul padrão de links/botões do iOS
          color:
              textColor ??
              (color == null
                  ? CupertinoColors.activeBlue
                  : CupertinoColors.white),

          fontSize: fontSize
        ),
      ),
    );
  }
  
  Widget _buildMaterialButton() {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        minimumSize: const Size(double.infinity, 52),
        alignment: alignment,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.black, width: 1.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (prefixImagePath != null) ...[
            Image.asset(prefixImagePath!, height: 35),
            const SizedBox(width: 10),
          ],
          Text(
            text,
            style: TextStyle(color: textColor, fontSize: fontSize),
          ),
        ],
      ),
    );
  }
}
