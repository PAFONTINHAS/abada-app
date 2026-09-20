import 'package:flutter/material.dart';


class StandardScaffoldBodyWidget extends StatelessWidget {
/// Widget com objetivo de garantir a padronização do corpo da Scaffold.
/// - Conta com uma SafeArea que os controles do dipositivo não sobreponham os componentes
/// - Conta com um SingleChildScrollView para evitar overflow vertical
/// - Conta com um padding padrão (mas personalizável) que garante o espaçamento ideal
  const StandardScaffoldBodyWidget({
    super.key, 
    required this.child, 
    this.padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 10)
  });

  final EdgeInsetsGeometry? padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: padding,
        child:  child,
      )
    );
  }
}