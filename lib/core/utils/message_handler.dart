import '../errors/failure.dart';
import 'package:flutter/material.dart';

/// Gerenciador global de mensagens da aplicação
/// 
/// Responsável por exibir mensagens de sucesso, erro e informação
/// de forma padronizada usando SnackBar.
/// 
/// Uso:
/// ```dart
/// MessageHandler.showSuccess(context, 'Operação realizada com sucesso!');
/// MessageHandler.showError(context, 'Erro ao realizar operação');
/// MessageHandler.showFailure(context, failure);
/// ```
class MessageHandler {

  MessageHandler ._();
  
  /// Exibe uma mensagem de sucesso
  static void showSuccess(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle,
    );
  }

  static void clearSnackbar(BuildContext context){
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
  }

  static void closeSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  /// Exibe uma mensagem de erro
  static void showError(BuildContext context, String message) {

    _showSnackBar(
      context,
      message,
      backgroundColor: Colors.red,
      icon: Icons.error,
    );
  }

  /// Exibe uma mensagem de informação
  static void showInfo(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      backgroundColor: Colors.blue,
      icon: Icons.info,
    );
  }

  /// Exibe uma mensagem de aviso
  static void showWarning(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      backgroundColor: Colors.orange,
      icon: Icons.warning,
    );
  }

  /// Exibe uma mensagem baseada em um Failure
  /// Mapeia automaticamente o tipo de Failure para a cor apropriada
  static void showFailure(BuildContext context, Failure failure) {
    Color backgroundColor;
    IconData icon;

    // Mapeia o tipo de Failure para cor e ícone apropriados
    switch (failure.runtimeType) {
      case ValidationFailure _:
        backgroundColor = Colors.orange;
        icon = Icons.warning;
        break;
      case NetworkFailure _:
        backgroundColor = Colors.red;
        icon = Icons.wifi_off;
        break;
      case UnauthorizedFailure _:
        backgroundColor = Colors.red;
        icon = Icons.lock;
        break;
      case NotFoundFailure _:
        backgroundColor = Colors.orange;
        icon = Icons.search_off;
        break;
      case TimeoutFailure _:
        backgroundColor = Colors.orange;
        icon = Icons.access_time;
        break;
      default:
        backgroundColor = Colors.red;
        icon = Icons.error;
    }

    _showSnackBar(
      context,
      failure.message,
      backgroundColor: backgroundColor,
      icon: icon,
    );
  }

  /// Método privado para exibir o SnackBar
  static void _showSnackBar(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    required IconData icon,
    Duration duration = const Duration(seconds: 3),
  }) {

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            // O SnackBar fecha automaticamente ao clicar no action
          },
        ),
      ),
    );
  }
}
