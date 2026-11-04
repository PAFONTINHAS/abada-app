import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/router/route_controller.dart';
import 'package:sistema_abada_capoeira/core/utils/mask_formatter.dart';
import 'package:sistema_abada_capoeira/core/utils/app_message_handler.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/payment_method.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_subscription_controller.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_details_subscription_controller.dart';

class EventCheckoutBottomSheetWidget extends StatefulWidget {
  final EventEntity event;

  const EventCheckoutBottomSheetWidget({super.key, required this.event});

  @override
  State<EventCheckoutBottomSheetWidget> createState() =>
      _EventCheckoutBottomSheetWidgetState();
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

    final formattedTotal = controller.totalAmount == 0.0
        ? 'GRATUITO'
        : MaskFormatter.convertToReais(
          MaskFormatter.convertMoneyDoubleToString(controller.totalAmount),
        );

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 20,
        left: 20,
        right: 20,
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
            if (mandatoryProducts.isNotEmpty) ...[
              const Text(
                "Itens Obrigatórios (Já inclusos)",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              ...mandatoryProducts.map(
                (prod) => Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: ColorConstants.backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: ColorConstants.borderColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        prod.product,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        MaskFormatter.convertToReais(
                          MaskFormatter.convertMoneyDoubleToString(prod.price),
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                          color: ColorConstants.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // 2. Seção de Produtos Opcionais para Seleção
            if (optionalProducts.isNotEmpty) ...[
              const Text(
                "Adicionar Produtos Opcionais",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              ...optionalProducts.map((prod) {
                final isSelected =
                    controller.selectedOptionalProducts.contains(prod);
                return CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  activeColor: Colors.green.shade700,
                  title: Text(
                    prod.product,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    MaskFormatter.convertToReais(
                      MaskFormatter.convertMoneyDoubleToString(prod.price),
                    ),
                    style: const TextStyle(
                      fontSize: 12,
                      color: ColorConstants.textSecondary,
                    ),
                  ),
                  value: isSelected,
                  onChanged: (checked) {

                    setState(() {
                      if (checked == true) {
                        controller.selectedOptionalProducts.add(prod);
                      } else {
                        controller.selectedOptionalProducts.remove(prod);
                      }
                    });
                  },
                );
              }),
              const SizedBox(height: 16),
            ],

            const Divider(color: ColorConstants.borderColor),
            const SizedBox(height: 8),

            // Resumo do Total Recalculado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Valor Total a Pagar:",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.textPrimary,
                  ),
                ),
                Text(
                  formattedTotal,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Seleção da Forma de Pagamento
            SegmentedButton<PaymentMethod>(
              segments: const [
                ButtonSegment(
                  value: PaymentMethod.pix,
                  label: Text("Pix"),
                  icon: Icon(Icons.qr_code),
                ),
                ButtonSegment(
                  value: PaymentMethod.creditCard,
                  label: Text("Cartão"),
                  icon: Icon(Icons.credit_card),
                ),
              ],
              selected: {controller.paymentMethod},
              onSelectionChanged: (set) {
                controller.setPaymentMethod(set.first);
              },
            ),
            const SizedBox(height: 16),

            // Dados Mockados da Forma de Pagamento
            if (controller.paymentMethod == PaymentMethod.pix) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "00020126580014br.gov.bcb.pix0136abada-capoeira-tcc-mock-key520400005303986540510.005802BR",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 20),
                      onPressed: () {
                        Clipboard.setData(const ClipboardData(
                          text:
                              "00020126580014br.gov.bcb.pix0136abada-capoeira-tcc-mock-key520400005303986540510.005802BR",
                        ));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Código Pix copiado!')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ] else ...[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Número do Cartão (Simulação)",
                  hintText: "4000 0000 0000 0000",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],

            const SizedBox(height: 24),

            // Botão Confirmar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async{

                  final subscriptionController = context.read<EventSubscriptionController>();

                  if(controller.isProcessing) return;

                  final subscription = await controller.processPayment(user.uid);  

                  if(!context.mounted) return;

                  context.pop();

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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: controller.isProcessing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Finalizar e Pagar",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}