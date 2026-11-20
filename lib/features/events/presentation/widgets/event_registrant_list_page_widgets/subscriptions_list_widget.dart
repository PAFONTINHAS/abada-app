import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/router/route_controller.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/general_event_subscriptions_controller.dart';

class SubscriptionsListWidget extends StatelessWidget {
  const SubscriptionsListWidget({super.key, required this.event});

  final EventEntity event;

  @override
  Widget build(BuildContext context) {
    return Consumer<GeneralEventSubscriptionsController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: ColorConstants.indigoColor),
                SizedBox(height: 16),
                Text(
                  "Carregando inscrições...",
                  style: TextStyle(color: ColorConstants.textSecondary),
                ),
              ],
            ),
          );
        }

        if (controller.errorMessage != null) {
          return Center(
            child: Text(
              "Erro: ${controller.errorMessage}",
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (controller.registrantsNames.isEmpty) {
          return const Center(
            child: Text(
              "Nenhuma inscrição encontrada para este evento.",
              style: TextStyle(color: ColorConstants.textSecondary),
            ),
          );
        }

        return ListView.separated(
          itemCount: controller.registrantsNames.length,
          separatorBuilder: (context, index) =>
              const Divider(height: 1, color: ColorConstants.borderColor),
          itemBuilder: (context, index) {
            final subscriptionView = controller.registrantsNames[index];

            // Identifica se é uma inscrição de menor de idade
            final isMinor = subscriptionView.isMinor;

            final userName = subscriptionView.userNickname != "-"
                ? "${subscriptionView.userName} - ${subscriptionView.userNickname}"
                : subscriptionView.userName;

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              leading: CircleAvatar(
                backgroundColor: isMinor
                    ? Colors.orange.shade100
                    : Colors.green.shade100,
                child: Icon(
                  isMinor ? Icons.escalator_warning : Icons.person,
                  color: isMinor
                      ? Colors.orange.shade700
                      : Colors.green.shade700,
                ),
              ),
              title: Text(
                userName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.textPrimary,
                ),
              ),
              subtitle: Text(
                "Código: ${subscriptionView.verificationCode}",
                style: const TextStyle(
                  fontSize: 13,
                  color: ColorConstants.textSecondary,
                  fontFamily: 'monospace',
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: ColorConstants.textSecondary,
              ),
              onTap: () => RouteController.redirectToEventReceiptPage(
                context: context,
                event: event,
                subscription: subscriptionView.subscription,
                showTotalPayed: false,
              ),
            );
          },
        );
      },
    );
  }
}
