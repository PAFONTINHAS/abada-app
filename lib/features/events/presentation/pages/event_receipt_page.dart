import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sistema_abada_capoeira/core/utils/date_controller.dart';
import 'package:sistema_abada_capoeira/core/utils/mask_formatter.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_subscription_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/payment_method.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/subscription_status.dart';

class EventReceiptPage extends StatelessWidget {
  final EventEntity event;
  final EventSubscriptionEntity subscription;

  const EventReceiptPage({
    super.key,
    required this.event,
    required this.subscription,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Comprovante de Inscrição",
          style: TextStyle(
            color: ColorConstants.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: ColorConstants.surfaceColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: ColorConstants.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Container principal do ingresso
            Container(
              decoration: BoxDecoration(
                color: ColorConstants.surfaceColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Cabeçalho do Evento
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: ColorConstants.indigoColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.eventName,
                          style: const TextStyle(
                            color: ColorConstants.whiteColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_month, color: Colors.white70, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              DateController.formatDDMMYYYYHM(event.eventInitDate),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Seção do QR Code
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const Text(
                          "Apresente este QR Code na entrada",
                          style: TextStyle(
                            fontSize: 14,
                            color: ColorConstants.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Geração do QR Code baseado no verificationCode
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: ColorConstants.borderColor),
                          ),
                          child: QrImageView(
                            data: subscription.verificationCode,
                            version: QrVersions.auto,
                            size: 200.0,
                            eyeStyle: const QrEyeStyle(
                              eyeShape: QrEyeShape.square,
                              color: ColorConstants.textPrimary,
                            ),
                            dataModuleStyle: const QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.square,
                              color: ColorConstants.textPrimary,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        Text(
                          subscription.verificationCode,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: ColorConstants.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Linha pontilhada (estilo ingresso)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(
                      color: ColorConstants.borderColor,
                      thickness: 2,
                      // Aqui você poderia usar um package de linha tracejada, 
                      // mas um divider simples já cumpre o papel visual
                    ),
                  ),

                  // Detalhes da Compra
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Detalhes da Inscrição",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow("Status", subscription.status.displayPortugueseText, isHighlight: true),
                        _buildInfoRow("Incrito em", DateController.formatDDMMYYYYHM(subscription.createdAt)),
                        _buildInfoRow("Pagamento", subscription.paymentMethod.displayPortugueseText),
                        
                        if (subscription.selectedProducts.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Text(
                            "Produtos Adicionais",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: ColorConstants.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...subscription.selectedProducts.map((p) => 
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("- ${p.product}", style: const TextStyle(color: ColorConstants.textSecondary)),
                                ],
                              ),
                            ),
                          ),
                        ],
                        
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(color: ColorConstants.borderColor),
                        ),
                        
                        // Total
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Pago",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ColorConstants.textPrimary,
                              ),
                            ),
                            Text(
                              MaskFormatter.convertToReais(
                                MaskFormatter.convertMoneyDoubleToString(subscription.totalValue)
                              ),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: ColorConstants.indigoColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Botão de Voltar
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(), // Ou GoRouter.pop() dependendo de como sua rota funciona
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: ColorConstants.indigoColor),
                ),
                child: const Text(
                  "Voltar aos Eventos",
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.indigoColor
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: ColorConstants.textSecondary,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isHighlight ? Colors.green.shade700 : ColorConstants.textPrimary,
              fontSize: 14,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}