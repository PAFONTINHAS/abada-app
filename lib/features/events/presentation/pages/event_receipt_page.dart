import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_subscription_entity.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_receipt_page_widgets/event_header_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_receipt_page_widgets/event_qr_code_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_receipt_page_widgets/purchase_details_widget.dart';

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
      body: StandardScaffoldBodyWidget(
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
                  EventHeaderWidget(event: event),
                  
                  // Seção do QR Code
                  EventQrCodeWidget(subscription: subscription),

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
                  PurchaseDetailsWidget(subscription: subscription),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Botão de Voltar
            // SizedBox(
            //   width: double.infinity,
            //   child: OutlinedButton(
            //     onPressed: () => Navigator.of(context).pop(), // Ou GoRouter.pop() dependendo de como sua rota funciona
            //     style: OutlinedButton.styleFrom(
            //       padding: const EdgeInsets.symmetric(vertical: 16),
            //       side: const BorderSide(color: ColorConstants.indigoColor),
            //     ),
            //     child: const Text(
            //       "Voltar aos Eventos",
            //       style: TextStyle(
            //         fontSize: 16, 
            //         fontWeight: FontWeight.bold,
            //         color: ColorConstants.indigoColor
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}