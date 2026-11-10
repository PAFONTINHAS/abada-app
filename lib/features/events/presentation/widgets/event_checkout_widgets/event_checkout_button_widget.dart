import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_details_subscription_controller.dart';

class EventCheckoutButtonWidget extends StatelessWidget {
  const EventCheckoutButtonWidget({super.key, required this.onProceed});

  final VoidCallback onProceed;

  @override
  Widget build(BuildContext context) {

    final controller = context.read<EventDetailsSubscriptionController>();
    return Selector<EventDetailsSubscriptionController, bool>(
      selector: (_, controller) => controller.isProcessing,
      builder: (context, isProcessing, child) {

        final isFreeEvent = controller.totalAmount == 0.00;
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onProceed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: isProcessing
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    !isFreeEvent ? "Finalizar e Pagar" : "Finalizar Inscrição",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
