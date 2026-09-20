import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/services/file_picker_service.dart';
import '../../domain/entities/fee_exemption_file_entity.dart';
import '../controllers/fee_exemption_complementation_controller.dart';
import '../controllers/fee_exemption_request_controller.dart';
import '../widgets/complementation_reason_card_widget.dart';
import '../widgets/declaration_upload_card_widget.dart';
import '../widgets/fee_exemption_request_info_widget.dart';
import '../widgets/selected_fee_exemption_file_widget.dart';
import '../widgets/submit_fee_exemption_button_widget.dart';

class FeeExemptionComplementationPage extends StatelessWidget {
  final String feeExemptionId;

  const FeeExemptionComplementationPage({
    super.key,
    required this.feeExemptionId,
  });

  @override
  Widget build(BuildContext context) {
    final requestController =
        context.watch<FeeExemptionRequestController>();

    final complementationController =
        context.watch<FeeExemptionComplementationController>();

    final request = requestController.request;

    if (request == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Solicitação não encontrada.',
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
          ),
        ),

        title: const Text(
          'Complementação da Solicitação',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF5936C8),
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FeeExemptionRequestInfoWidget(
                request: request,
              ),

              const SizedBox(height: 16),

              ComplementationReasonCardWidget(
                reason: request.complementationReason ??
                    'Nenhum motivo informado.',
              ),

              const SizedBox(height: 16),

              DeclarationUploadCardWidget(
                onSelectFile: () async {
                  final pickedFile =
                      await FilePickerService.pickPdf();

                  if (pickedFile == null) {
                    return;
                  }

                  final file = FeeExemptionFileEntity(
                    fileName: pickedFile.fileName,
                    bytes: pickedFile.bytes,
                  );

                  complementationController.selectFile(
                    file,
                  );
                },
              ),

              if (complementationController.selectedFile != null) ...[
                const SizedBox(height: 12),

                SelectedFeeExemptionFileWidget(
                  fileName:
                      complementationController.selectedFile!.fileName,
                  onRemove:
                      complementationController.clearSelectedFile,
                ),
              ],

              const SizedBox(height: 20),

              if (complementationController.errorMessage != null) ...[
                Text(
                  complementationController.errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 12),
              ],

              SubmitFeeExemptionButtonWidget(
                isLoading:
                    complementationController.isLoading,
                onPressed:
                    complementationController.isLoading
                        ? null
                        : () async {
                            final success =
                                await complementationController
                                    .submitComplementation(
                              feeExemptionId,
                            );

                            if (!context.mounted) {
                              return;
                            }

                            if (!success) {
                              return;
                            }

                            context.go(
                              '/fee-exemption/sent/$feeExemptionId',
                            );
                          },
              ),
            ],
          ),
        ),
      ),
    );
  }
}