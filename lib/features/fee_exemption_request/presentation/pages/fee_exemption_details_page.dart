import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/fee_exemption_documents_controller.dart';
import '../controllers/fee_exemption_request_controller.dart';
import '../widgets/fee_exemption_document_card_widget.dart';
import '../widgets/fee_exemption_request_info_widget.dart';
import '../widgets/fee_exemption_status_card_widget.dart';

class FeeExemptionDetailsPage extends StatefulWidget {
  final String feeExemptionId;

  const FeeExemptionDetailsPage({super.key, required this.feeExemptionId});

  @override
  State<FeeExemptionDetailsPage> createState() =>
      _FeeExemptionDetailsPageState();
}

class _FeeExemptionDetailsPageState extends State<FeeExemptionDetailsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeeExemptionRequestController>().getLoadRequest(
        widget.feeExemptionId,
      );

      context.read<FeeExemptionDocumentsController>().getLoadDocuments(
        widget.feeExemptionId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final requestController = context.watch<FeeExemptionRequestController>();

    final documentsController = context
        .watch<FeeExemptionDocumentsController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
        ),
        title: const Text(
          'Detalhes da Solicitação',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF5936C8),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(child: _buildBody(requestController, documentsController)),
    );
  }

  Widget _buildBody(
    FeeExemptionRequestController requestController,
    FeeExemptionDocumentsController documentsController,
  ) {
    if (requestController.isLoading || documentsController.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (requestController.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            requestController.errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    if (documentsController.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            documentsController.errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    if (requestController.request == null) {
      return const Center(child: Text('Solicitação não encontrada.'));
    }

    final request = requestController.request!;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FeeExemptionRequestInfoWidget(request: request),

          const SizedBox(height: 16),

          if (documentsController.documents.isNotEmpty)
            FeeExemptionDocumentCardWidget(
              document: documentsController.documents.last,
              onView: () async {
                final document = documentsController.documents.last;

                final url = await documentsController.getDocumentUrl(
                  document.storagePath,
                );

                if (url == null) {
                  return;
                }

                final uri = Uri.parse(url);

                await launchUrl(uri, mode: LaunchMode.externalApplication);
              },
            ),

          if (documentsController.documents.isEmpty) const _NoDocumentWidget(),

          const SizedBox(height: 16),

          FeeExemptionStatusCardWidget(
            request: request,
            onComplementation: () {
              context.push(
                '/fee-exemption/complementation/'
                '${request.idExemptionRequest}',
              );
            },
          ),
        ],
      ),
    );
  }
}

class _NoDocumentWidget extends StatelessWidget {
  const _NoDocumentWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F4FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: Color(0xFF5936C8)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Nenhum documento foi encontrado para esta solicitação.',
              style: TextStyle(fontSize: 13, color: Color(0xFF7C7890)),
            ),
          ),
        ],
      ),
    );
  }
}
