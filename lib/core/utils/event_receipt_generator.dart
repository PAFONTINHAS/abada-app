import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:sistema_abada_capoeira/core/utils/date_controller.dart';
import 'package:sistema_abada_capoeira/core/utils/mask_formatter.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_subscription_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/payment_method.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/subscription_status.dart';

class EventReceiptGenerator {
  static Future<Uint8List> generateReceipt({
    required EventEntity event,
    required EventSubscriptionEntity subscription,
    bool showTotalPayed = true,
  }) async {
    final pdf = pw.Document();

    final fontRegular = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();

    // Mapeamento das cores fiéis ao design do app
    const primaryIndigo = PdfColor.fromInt(0xFF3F51B5); // ColorConstants.indigoColor
    const textPrimary = PdfColor.fromInt(0xFF212121);
    const textSecondary = PdfColor.fromInt(0xFF757575);
    const borderColor = PdfColor.fromInt(0xFFE0E0E0);
    const surfaceColor = PdfColor.fromInt(0xFFFFFFFF);
    const statusGreen = PdfColor.fromInt(0xFF2E7D32);

    final isMinorSubscription = subscription.minorStudentSubscriptionData != null;
    final userName = isMinorSubscription
        ? subscription.minorStudentSubscriptionData!.studentFullName
        : subscription.userName;

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(32),
        theme: pw.ThemeData.withFont(
          base: fontRegular,
          bold: fontBold,
        ),
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Container(
              width: 440, // Largura estilo cartão/ingresso
              decoration: pw.BoxDecoration(
                color: surfaceColor,
                borderRadius: pw.BorderRadius.circular(16),
                border: pw.Border.all(color: borderColor, width: 1),
              ),
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  // --- Cabeçalho do Evento ---
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(20),
                    decoration: const pw.BoxDecoration(
                      color: primaryIndigo,
                      borderRadius: pw.BorderRadius.vertical(top: pw.Radius.circular(15)),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text(
                          event.eventName,
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          DateController.formatEventDate(
                            event.eventInitDate,
                            event.eventEndingDate,
                          ),
                          style: const pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 13,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                        pw.SizedBox(height: 6),
                        pw.Text(
                          event.eventLocation,
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 13,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // --- Seção do QR Code ---
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(20),
                    child: pw.Column(
                      children: [
                        pw.Text(
                          "Apresente este QR Code na entrada",
                          style: const pw.TextStyle(
                            fontSize: 12,
                            color: textSecondary,
                          ),
                        ),
                        pw.SizedBox(height: 12),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(10),
                          decoration: pw.BoxDecoration(
                            color: PdfColors.white,
                            borderRadius: pw.BorderRadius.circular(12),
                            border: pw.Border.all(color: borderColor),
                          ),
                          child: pw.BarcodeWidget(
                            data: subscription.verificationCode,
                            barcode: pw.Barcode.qrCode(),
                            width: 150,
                            height: 150,
                            color: textPrimary,
                          ),
                        ),
                        pw.SizedBox(height: 12),
                        pw.Text(
                          subscription.verificationCode,
                          style: pw.TextStyle(
                            fontSize: 15,
                            fontWeight: pw.FontWeight.bold,
                            letterSpacing: 2,
                            color: textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- Linha Divisória Pontilhada/Contínua ---
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 20),
                    child: pw.Divider(color: borderColor, thickness: 1.5),
                  ),

                  // --- Detalhes da Compra ---
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(20),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "Detalhes da Inscrição",
                          style: pw.TextStyle(
                            fontSize: 15,
                            fontWeight: pw.FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),
                        pw.SizedBox(height: 14),

                        _buildInfoRow(
                          "Status",
                          subscription.status.displayPortugueseText,
                          valueColor: statusGreen,
                          isBold: true,
                        ),

                        _buildInfoRow("Nome", userName),

                        if (isMinorSubscription) ...[
                          _buildInfoRow(
                            'Responsável Legal',
                            subscription.minorStudentSubscriptionData!.legalGuardianName,
                          ),
                          _buildInfoRow(
                            'Telefone do Responsável',
                            subscription.minorStudentSubscriptionData!.legalGuardianPhoneNumber,
                          ),
                        ],

                        _buildInfoRow(
                          "Inscrito em",
                          DateController.formatDDMMYYYYHM(subscription.createdAt),
                        ),

                        if (subscription.totalValue > 0.00)
                          _buildInfoRow(
                            "Pagamento",
                            subscription.paymentMethod.displayPortugueseText,
                          ),

                        if (subscription.selectedProducts.isNotEmpty) ...[
                          pw.SizedBox(height: 12),
                          pw.Text(
                            "Produtos Adicionais",
                            style: pw.TextStyle(
                              fontSize: 13,
                              fontWeight: pw.FontWeight.bold,
                              color: textPrimary,
                            ),
                          ),
                          pw.SizedBox(height: 6),
                          ...subscription.selectedProducts.map(
                            (p) => pw.Padding(
                              padding: const pw.EdgeInsets.only(bottom: 3),
                              child: pw.Text(
                                "- ${p.product}",
                                style: const pw.TextStyle(
                                  color: textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],

                        if (showTotalPayed && subscription.totalValue > 0.00) ...[
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(vertical: 10),
                            child: pw.Divider(color: borderColor),
                          ),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                "Total Pago",
                                style: pw.TextStyle(
                                  fontSize: 15,
                                  fontWeight: pw.FontWeight.bold,
                                  color: textPrimary,
                                ),
                              ),
                              pw.Text(
                                MaskFormatter.convertToReais(
                                  MaskFormatter.convertMoneyDoubleToString(
                                    subscription.totalValue,
                                  ),
                                ),
                                style: pw.TextStyle(
                                  fontSize: 16,
                                  fontWeight: pw.FontWeight.bold,
                                  color: primaryIndigo,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildInfoRow(
    String label,
    String value, {
    PdfColor valueColor = const PdfColor.fromInt(0xFF212121),
    bool isBold = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(
              color: PdfColor.fromInt(0xFF757575),
              fontSize: 12,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              color: valueColor,
              fontSize: 12,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}