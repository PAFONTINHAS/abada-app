import 'package:pdf/pdf.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sistema_abada_capoeira/core/utils/date_formatter.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/user_profile_entity.dart';

class TuscaReceiptGenerator{

  static Future<Uint8List> generateReceipt(UserProfileEntity profile) async{

    final pdf = pw.Document();

    final fontRegular = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();

    final validUntil = DateFormatter.formatDDMMYYYY(profile.tusca.validUntil);

    final protocol = profile.tusca.protocol ?? "00000";

    final validatorName = profile.tusca.validatorName ?? 'Diretoria Abadá Capoeira';
    final rawValidatorId = profile.tusca.validatorId ?? '00000';
    final validatorShortId = rawValidatorId.length > 5 ? rawValidatorId.substring(0, 5).toUpperCase() : rawValidatorId;

    pdf.addPage(
      
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(
          base: fontRegular,
          bold: fontBold
        ),
        build: (pw.Context context){

          return pw.Container(
            padding: const pw.EdgeInsets.all(40),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 2)
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Center(
                  child: pw.Text(
                    'COMPROVANTE DE REGULARIDADE TUSCA',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    textAlign: pw.TextAlign.center
                  )
                ),

                pw.SizedBox(height: 40),
                pw.Text(
                  "Declaro que ${profile.fullName}, também conhecido como ${profile.nickname} está regular com a TUSCA",
                  style: const pw.TextStyle(fontSize: 16)
                ),

                pw.SizedBox(height: 30),
                pw.Divider(),
                pw.SizedBox(height: 20),
                pw.Text('Identificação do Professor: ${profile.fullName} - ${profile.nickname}', style: const pw.TextStyle(fontSize: 14)),
                pw.SizedBox(height: 10),
                pw.Text('Número de Protocolo: $protocol', style: const pw.TextStyle(fontSize: 14)),
                pw.SizedBox(height: 10),
                pw.Text('Período de Validade: Até $validUntil', style: const pw.TextStyle(fontSize: 14)),
                pw.SizedBox(height: 10),
                pw.Text('Atestado por: $validatorName (Auth: $validatorShortId)', style: const pw.TextStyle(fontSize: 14)),

                pw.SizedBox(height: 50),
                
                pw.Center(
                  child: pw.Text(
                    'Documento gerado digitalmente pelo Sistema Abadá Capoeira',
                    style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                  ),
                )
              ]
            )
          );
        }
      ),
    );

    return pdf.save();
  }
}