import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_requests_controller.dart';

class ShowReasonModalWidget extends StatelessWidget {
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
  final Function(String reason) onSubmit;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<EventRequestsController>();

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
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorConstants.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller.reasonController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: labelText,
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
                backgroundColor: buttonColor,
                foregroundColor: ColorConstants.whiteColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                final reason = controller.reasonController.text.trim();
                if (reason.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Por favor, preencha a justificativa."),
                    ),
                  );
                  return;
                }
                Navigator.pop(context);
                onSubmit(reason);
              },
              child: const Text(
                "Confirmar e Enviar",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
