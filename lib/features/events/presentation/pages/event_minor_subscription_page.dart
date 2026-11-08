import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/router/route_controller.dart';
import 'package:sistema_abada_capoeira/core/utils/app_message_handler.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_subscription_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_details_subscription_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_checkout_widgets/event_checkout_button_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_checkout_widgets/mandatory_products_list_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_checkout_widgets/select_optional_products_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_checkout_widgets/minor_info_subscription_form_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_details_page_widgets/total_subscription_value_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_checkout_widgets/legal_guardian_consent_checkbox_widget.dart';

class EventMinorSubscriptionPage extends StatefulWidget {
  final EventEntity event;

  const EventMinorSubscriptionPage({super.key, required this.event});

  @override
  State<EventMinorSubscriptionPage> createState() =>
      _EventMinorSubscriptionPageState();
}

class _EventMinorSubscriptionPageState extends State<EventMinorSubscriptionPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<EventDetailsSubscriptionController>();
      controller.setEvent(widget.event);
    });
  }


  @override
  Widget build(BuildContext context) {

    final profileController = context.read<ProfileController>();
    final user = profileController.userProfile;
    final controller = context.watch<EventDetailsSubscriptionController>();

    final mandatoryProducts = widget.event.products
        .where((p) => p.mandatory)
        .toList();
    final optionalProducts = widget.event.products
        .where((p) => !p.mandatory)
        .toList();

    return Scaffold(
      body: StandardScaffoldBodyWidget(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho
              Text(
                "Inscrição de Menor de Idade",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              
              const MinorInfoSubscriptionFormWidget(),
              
              const SizedBox(height: 16),

              // --- SEÇÃO: PRODUTOS OBRIGATÓRIOS ---
              if (mandatoryProducts.isNotEmpty) MandatoryProductsListWidget(mandatoryProducts: mandatoryProducts),

              // --- SEÇÃO: PRODUTOS OPCIONAIS ---
              if (optionalProducts.isNotEmpty) SelectOptionalProductsWidget(optionalProducts: optionalProducts),

              const Divider(color: ColorConstants.borderColor),
              const SizedBox(height: 8),

              // Resumo do Total Recalculado
              const TotalSubscriptionValueWidget(),
              
              const SizedBox(height: 20),

              // Seleção da Forma de Pagamento

              const SizedBox(height: 20),

              // --- CHECKBOX LGPD / CONSENTIMENTO (RN05) ---
              const LegalGuardianConsentCheckboxWidget(),

              const SizedBox(height: 24),

              // Botão Confirmar
              EventCheckoutButtonWidget(
                onProceed: () async {
                  final subscriptionController = context.read<EventSubscriptionController>();

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
      ),
    );
  }
}
