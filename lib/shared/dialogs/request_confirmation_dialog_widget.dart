import 'package:flutter/material.dart';
import 'request_dialog_widget.dart';

/// Confirms an action without collecting input or knowing feature rules.
class RequestConfirmationDialogWidget extends StatefulWidget {
  final String title;
  final String description;
  final String confirmLabel;
  final Color actionColor;
  final IconData icon;
  final Future<bool> Function() onConfirm;

  const RequestConfirmationDialogWidget({
    super.key,
    required this.title,
    required this.description,
    required this.confirmLabel,
    required this.actionColor,
    required this.icon,
    required this.onConfirm,
  });

  @override
  State<RequestConfirmationDialogWidget> createState() =>
      _RequestConfirmationDialogWidgetState();
}

class _RequestConfirmationDialogWidgetState
    extends State<RequestConfirmationDialogWidget> {
  bool _isLoading = false;

  Future<void> _confirm() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final success = await widget.onConfirm();

      if (!mounted) return;

      if (success) {
        Navigator.of(context).pop(true);
      }
    } catch (error, stackTrace) {
      debugPrint('Confirmation action failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível concluir a ação. Tente novamente.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RequestDialogWidget(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              RequestDialogWidget.actionIcon(
                icon: widget.icon,
                color: widget.actionColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                onPressed: _isLoading
                    ? null
                    : () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(widget.description),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: _isLoading
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: _isLoading ? null : _confirm,
                  style: FilledButton.styleFrom(
                    backgroundColor: widget.actionColor,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(widget.confirmLabel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
