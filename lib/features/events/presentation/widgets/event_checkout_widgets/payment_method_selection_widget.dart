import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/payment_method.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_details_subscription_controller.dart';

class PaymentMethodSelectionWidget extends StatelessWidget {
  const PaymentMethodSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<EventDetailsSubscriptionController>();

    return Selector<EventDetailsSubscriptionController, double>(
      selector: (_, controller) => controller.totalAmount,
      builder: (context, totalAmount, child) {
        if (totalAmount <= 0.00) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

            // Dados da Forma de Pagamento (Mock)
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
                        Clipboard.setData(
                          const ClipboardData(
                            text:
                                "00020126580014br.gov.bcb.pix0136abada-capoeira-tcc-mock-key520400005303986540510.005802BR",
                          ),
                        );
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
          ],
        );
      },
    );
  }
}
