import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/services/file_picker_service.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/domain/entities/fee_exemption_file_entity.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/presentation/controllers/fee_exemption_request_controller.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/presentation/widgets/declaration_download_card_widget.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/presentation/widgets/declaration_upload_card_widget.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/presentation/widgets/fee_exemption_header_widget.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/presentation/widgets/fee_exemption_info_card_widget.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/presentation/widgets/selected_fee_exemption_file_widget.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/presentation/widgets/submit_fee_exemption_button_widget.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/domain/entities/fee_exemption_request_entity.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/domain/entities/fee_exemption_request_status_enum.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/core/services/asset_file_download_service.dart';

class FeeExemptionRequestPage extends StatelessWidget {
  const FeeExemptionRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final feeExemptionController = context
        .watch<FeeExemptionRequestController>();

    final profileController = context.watch<ProfileController>();

    if (profileController.status != ProfileLoadStatus.loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final profile = profileController.userProfile;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              const FeeExemptionHeaderWidget(),

              const SizedBox(height: 20),

              DeclarationDownloadCardWidget(
                onTap: () async {
                  final success = await AssetFileDownloadService.openPdf(
                    assetPath: 'assets/documents/declaracao_isencao.pdf',
                    fileName: 'declaracao_isencao.pdf',
                  );

                  if (!context.mounted) {
                    return;
                  }

                  if (!success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Não foi possível abrir a declaração.'),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),

              DeclarationUploadCardWidget(
                onSelectFile: () async {
                  final pickedFile = await FilePickerService.pickPdf();

                  if (pickedFile == null) {
                    return;
                  }

                  final file = FeeExemptionFileEntity(
                    fileName: pickedFile.fileName,
                    bytes: pickedFile.bytes,
                  );

                  feeExemptionController.selectFile(file);
                },
              ),

              if (feeExemptionController.selectedFile != null) ...[
                const SizedBox(height: 12),

                SelectedFeeExemptionFileWidget(
                  fileName: feeExemptionController.selectedFile!.fileName,
                  onRemove: feeExemptionController.clearSelectedFile,
                ),
              ],

              const SizedBox(height: 16),

              const FeeExemptionInfoCardWidget(),

              const SizedBox(height: 20),

              SubmitFeeExemptionButtonWidget(
                isLoading: feeExemptionController.isLoading,
                onPressed: feeExemptionController.isLoading
                    ? null
                    : () async {
                        final request = FeeExemptionRequestEntity(
                          idExemptionRequest: '',
                          professorId: profile.uid,
                          professorName: profile.fullName,
                          status: FeeExemptionStatus.requested,
                          requestedAt: DateTime.now(),
                        );

                        final feeExemptionId = await feeExemptionController
                            .submitRequest(request);

                        if (!context.mounted) {
                          return;
                        }

                        if (feeExemptionId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                feeExemptionController.errorMessage ??
                                    'Não foi possível enviar a solicitação.',
                              ),
                            ),
                          );

                          return;
                        }

                        context.push('/fee-exemption/sent/$feeExemptionId');
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
