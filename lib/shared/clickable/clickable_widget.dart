import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';

class ClickableWidget extends StatelessWidget {
  /// Widget com objetivo de garantir a padronização dos componentes clicáveis e dar o retorno de toque para o usuário.
  /// Inclui widgets de Material e Inkwell que deixam o componente mais sofisticado e intuitivo
  const ClickableWidget({
    super.key,
    required this.padding,
    required this.onTap,
    required this.child,
    this.color = ColorConstants.whiteColor,
  });

  final Widget child;
  final VoidCallback onTap;
  final Color color;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        shadowColor: const Color.fromARGB(253, 0, 0, 0),
        child: InkWell(onTap: onTap, child: child),
      ),
    );
  }
}
