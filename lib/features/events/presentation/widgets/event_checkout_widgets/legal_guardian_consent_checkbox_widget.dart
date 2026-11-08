import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_minor_subscription_controller.dart';

class LegalGuardianConsentCheckboxWidget extends StatelessWidget {
  const LegalGuardianConsentCheckboxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<EventMinorSubscriptionController>();

    return FormField<bool>(
      initialValue: controller.hasGuardianConsent,
      validator: (value) {
        if (value != true) {
          return 'É obrigatório confirmar a autorização do responsável legal.';
        }
        return null;
      },
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              activeColor: Colors.green.shade700,
              value: controller.hasGuardianConsent,
              onChanged: (checked) =>
                  controller.setHasGuardianConsent(checked ?? false),
              title: const Text(
                "Declaro que obtive a autorização prévia do responsável legal para a inscrição do menor neste evento.",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.textPrimary,
                ),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 4),
                child: Text(
                  state.errorText!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
