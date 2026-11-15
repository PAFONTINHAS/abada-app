import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:sistema_abada_capoeira/core/utils/date_controller.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_subscription_entity.dart';

class EventRegistrantsListGenerator {
  static Future<Uint8List> generatePdf({
    required EventEntity event,
    required List<EventSubscriptionEntity> subscriptions,
  }) async {
    final pdf = pw.Document();

    final fontRegular = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();

    final eventDate = DateController.formatEventDate(
      event.eventInitDate,
      event.eventEndingDate,
    );

    // Definição de estilos/cores institucionais limpos
    const primaryColor = PdfColor.fromInt(0xFF3F51B5);
    const textColor = PdfColor.fromInt(0xFF212121);
    const subtextColor = PdfColor.fromInt(0xFF616161);
    const headerBgColor = PdfColor.fromInt(0xFFEEEEEE);
    const borderColor = PdfColor.fromInt(0xFFE0E0E0);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        theme: pw.ThemeData.withFont(
          base: fontRegular,
          bold: fontBold,
        ),
        header: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          event.eventName,
                          style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'Data: $eventDate',
                          style: const pw.TextStyle(
                            fontSize: 10,
                            color: subtextColor,
                          ),
                        ),
                        pw.Text(
                          'Local: ${event.eventLocation}',
                          style: const pw.TextStyle(
                            fontSize: 10,
                            color: subtextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'LISTA DE INSCRITOS',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Total: ${subscriptions.length} participantes',
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: subtextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Divider(color: primaryColor, thickness: 1.5),
              pw.SizedBox(height: 10),
            ],
          );
        },
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 10),
            child: pw.Text(
              'Página ${context.pageNumber} de ${context.pagesCount}',
              style: const pw.TextStyle(fontSize: 9, color: subtextColor),
            ),
          );
        },
        build: (pw.Context context) {
          final headers = [
            'Código',
            'Nome',
            'Apelido',
            'Responsável',
            'Tel. Responsável'
          ];

          final data = subscriptions.map((sub) {
            final isMinor = sub.minorStudentSubscriptionData != null;

            final name = isMinor
                ? sub.minorStudentSubscriptionData!.studentFullName
                : sub.userName;

            String nickname = isMinor
                ? sub.minorStudentSubscriptionData!.studentNickname
                : sub.userNickname;

            if(nickname.isEmpty){
              nickname = '-';
            }

            final guardianName = isMinor
                ? sub.minorStudentSubscriptionData!.legalGuardianName
                : '-';

            final guardianPhone = isMinor
                ? sub.minorStudentSubscriptionData!.legalGuardianPhoneNumber
                : '-';

            return [
              sub.verificationCode,
              name,
              nickname,
              guardianName,
              guardianPhone,
            ];
          }).toList();

          data.sort((a, b) {
            final nameComparison = a[1].toLowerCase().compareTo(
                  b[1].toLowerCase(),
                );
            return nameComparison != 0
                ? nameComparison
                : a[2].toLowerCase().compareTo(b[2].toLowerCase());
          });

          return [
            pw.TableHelper.fromTextArray(
              headers: headers,
              data: data,
              border: pw.TableBorder.all(color: borderColor, width: 0.5),
              headerStyle: pw.TextStyle(
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
                color: textColor,
              ),
              headerDecoration: const pw.BoxDecoration(color: headerBgColor),
              cellStyle: const pw.TextStyle(
                fontSize: 8,
                color: textColor,
              ),
              cellPadding: const pw.EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 6,
              ),
              columnWidths: const {
                0: pw.FlexColumnWidth(1.2), // Código
                1: pw.FlexColumnWidth(2.5), // Nome
                2: pw.FlexColumnWidth(1.5), // Apelido
                3: pw.FlexColumnWidth(2.2), // Responsável
                4: pw.FlexColumnWidth(1.6), // Tel. Responsável
              },
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }
}