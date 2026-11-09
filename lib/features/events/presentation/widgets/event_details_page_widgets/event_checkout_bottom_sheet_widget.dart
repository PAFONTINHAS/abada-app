import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/router/route_controller.dart';
import 'package:sistema_abada_capoeira/core/utils/app_message_handler.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/user_event_subscription_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_details_subscription_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_checkout_widgets/event_checkout_button_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_checkout_widgets/mandatory_products_list_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_checkout_widgets/payment_method_selection_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_checkout_widgets/select_optional_products_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_details_page_widgets/total_subscription_value_widget.dart';

class EventCheckoutBottomSheetWidget extends StatefulWidget {
  final EventEntity event;

  const EventCheckoutBottomSheetWidget({super.key, required this.event});
  @override
  State<EventCheckoutBottomSheetWidget> createState() => _EventCheckoutBottomSheetWidgetState();
}

class _EventCheckoutBottomSheetWidgetState extends State<EventCheckoutBottomSheetWidget> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_){
      
      final controller = context.read<EventDetailsSubscriptionController>();

      controller.setEvent(widget.event);
    });
  }

  @override
  Widget build(BuildContext context) {

    final profileController = context.read<ProfileController>();
    final user = profileController.userProfile;

    final controller = context.watch<EventDetailsSubscriptionController>();
    final mandatoryProducts = widget.event.products.where((p) => p.mandatory).toList();
    final optionalProducts = widget.event.products.where((p) => !p.mandatory).toList();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 20, left: 20, right: 20
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho
            Text(
              "Inscrição & Checkout",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.textPrimary,
                  ),
            ),
            const SizedBox(height: 16),

            // 1. Seção de Produtos Obrigatórios Incluídos
            if (mandatoryProducts.isNotEmpty) MandatoryProductsListWidget(mandatoryProducts: mandatoryProducts),

            // 2. Seção de Produtos Opcionais para Seleção
            if (optionalProducts.isNotEmpty) SelectOptionalProductsWidget(optionalProducts: optionalProducts),

            const Divider(color: ColorConstants.borderColor),
            const SizedBox(height: 8),

            // Resumo do Total Recalculado
            const TotalSubscriptionValueWidget(),

            const SizedBox(height: 20),

            // Seleção da Forma de Pagamento
            const PaymentMethodSelectionWidget(),

            const SizedBox(height: 24),

            // Botão Confirmar
            EventCheckoutButtonWidget(
              onProceed: () async {
                final subscriptionController = context
                    .read<UserEventSubscriptionController>();

                if (controller.isProcessing) return;

                final subscription = await controller.processPayment(
                  user.uid,
                  user.fullName,
                );

                if (!context.mounted) return;

                // context.pop();

                if (subscription != null) {
                  AppMessageHandler.showSuccess(
                    context,
                    "Inscrição e produtos confirmados com sucesso!",
                  );

                  subscriptionController.addEventSubscription(subscription);

                  RouteController.pushReplacementEventReceiptPage(
                    context: context,
                    event: widget.event,
                    subscription: subscription,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}