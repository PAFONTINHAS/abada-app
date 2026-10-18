import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/utils/message_handler.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/custom_text_input.dart';
import 'request_dialog_widget.dart';

/// Collects a required free-text justification and delegates the action.
/// Feature-specific behavior stays in the supplied callback.
class RequestJustificationDialogWidget extends StatefulWidget {
  final String title;
  final String? description;
  final String hintText;
  final String confirmLabel;
  final Color actionColor;
  final IconData icon;
  final Future<bool> Function(String justification) onConfirm;

  const RequestJustificationDialogWidget({
    super.key,
    required this.title,
    this.description,
    required this.hintText,
    required this.confirmLabel,
    required this.actionColor,
    required this.icon,
    required this.onConfirm,
  });

  @override
  State<RequestJustificationDialogWidget> createState() =>
      _RequestJustificationDialogWidgetState();
}

class _RequestJustificationDialogWidgetState
    extends State<RequestJustificationDialogWidget> {
  // Each dialog instance owns its text input and loading state.
  final _justificationController = TextEditingController();
  bool _isLoading = false;

  Future<void> _confirm() async {
    if (_isLoading) return;

    final justification = _justificationController.text.trim();

    if (justification.isEmpty) {
      MessageHandler.showWarning(context, 'Informe a justificativa.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await widget.onConfirm(justification);

      if (!mounted) return;

      if (success) {
        Navigator.of(context).pop(true);
      }
    } catch (error, stackTrace) {
      debugPrint('Justification action failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      MessageHandler.showError(
        context,
        'Não foi possível concluir a ação. Tente novamente.',
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    // Release the text controller when this dialog leaves the widget tree.
    _justificationController.dispose();
    super.dispose();
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
          if (widget.description != null &&
              widget.description!.trim().isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(widget.description!),
          ],
          const SizedBox(height: 20),
          CustomTextInput(
            label: 'Justificativa',
            controller: _justificationController,
            enabled: !_isLoading,
            hintText: widget.hintText,
            maxLines: 3,
            keyboardType: TextInputType.multiline,
            onFocusBorderColor: widget.actionColor,
          ),
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
