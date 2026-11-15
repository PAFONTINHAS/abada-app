import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/utils/event_receipt_generator.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_subscription_entity.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_receipt_page_widgets/event_header_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_receipt_page_widgets/event_qr_code_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_receipt_page_widgets/purchase_details_widget.dart';

class EventReceiptPage extends StatelessWidget {
  final EventEntity event;
  final EventSubscriptionEntity subscription;
  final bool showTotalPayed;

  const EventReceiptPage({
    super.key,
    required this.event,
    required this.subscription,
    this.showTotalPayed = true,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.red,),
            tooltip: "Exportar PDF",
            onPressed: () async {

              final pdfBytes = await EventReceiptGenerator.generateReceipt(
                event: event,
                subscription: subscription,
                showTotalPayed: showTotalPayed,
              );

              await Printing.sharePdf(
                bytes: pdfBytes,
                filename:'comprovante_inscricao_${subscription.verificationCode}.pdf',
              );

            },
          ),
        ],
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
                    ),
                  ),

                  // Detalhes da Compra
                  PurchaseDetailsWidget(subscription: subscription, showTotalPayed: showTotalPayed,),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Botão de Voltar
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(), 
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
}