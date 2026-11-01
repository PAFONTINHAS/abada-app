import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';

class ShowReasonModalWidget extends StatefulWidget {
  const ShowReasonModalWidget({
    super.key,
    required this.title,
    required this.onSubmit,
    required this.labelText,
    required this.buttonColor,
  });

  final String title;
  final String labelText;
  final Color buttonColor;
  final Future<bool> Function(String reason) onSubmit;

  @override
  State<ShowReasonModalWidget> createState() => _ShowReasonModalWidgetState();
}

class _ShowReasonModalWidgetState extends State<ShowReasonModalWidget> {
  final TextEditingController _reasonController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final reason = _reasonController.text.trim();

    if (reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha a justificativa.')),
      );
      return;
    }

    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final success = await widget.onSubmit(reason);

      if (!mounted) return;

      if (success) {
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível concluir a operação.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorConstants.textPrimary,
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: _reasonController,
            maxLines: 4,
            enabled: !_isSubmitting,
            decoration: InputDecoration(
              hintText: widget.labelText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: ColorConstants.borderColor),
              ),
              filled: true,
              fillColor: ColorConstants.backgroundColor,
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.buttonColor,
                foregroundColor: ColorConstants.whiteColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Confirmar e Enviar',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
