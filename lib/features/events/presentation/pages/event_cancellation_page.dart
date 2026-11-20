import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sistema_abada_capoeira/core/utils/mask_formatter.dart';
import 'package:sistema_abada_capoeira/core/router/route_controller.dart';
import 'package:sistema_abada_capoeira/core/utils/app_message_handler.dart';
import 'package:sistema_abada_capoeira/core/router/redirection_method.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_cancellation_controller.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/custom_text_input.dart';
import 'package:sistema_abada_capoeira/shared/inputs/dropdown_input_widget.dart';

class EventCancellationPage extends StatefulWidget {
  const EventCancellationPage({super.key, required this.event});

  final EventEntity event;

  @override
  State<EventCancellationPage> createState() => _EventCancellationPageState();
}

class _EventCancellationPageState extends State<EventCancellationPage> {

  @override
  Widget build(BuildContext context) {

    final eventValue = MaskFormatter.convertMoneyStringToDouble(widget.event.eventValue);
    final eventImage = widget.event.eventImagePath;
    final genericEventImage = "assets/images/generic_event_image.jpg";
    final eventHasImage = eventImage != null;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: const Text('Cancelar evento'),
      ),
      body: StandardScaffoldBodyWidget(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Consumer<EventCancellationController>(builder:(context, controller, child) {

                  
        return Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: eventHasImage ?   CachedNetworkImage(
                imageUrl: eventImage,
                height: 138,
                fit: BoxFit.cover,
                errorWidget : (context, error, stackTrace) => Container(
                  height: 138,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported, size: 40),
                ),
              ) : Image.asset(
                genericEventImage,
                height: 138,
                fit: BoxFit.cover,
                errorBuilder : (context, error, stackTrace) => Container(
                  height: 138,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported, size: 40),
                ),
              ) ,
            ),
            const SizedBox(height: 14),
            Text(
              widget.event.eventName,
              style: const TextStyle(
                color: Color(0xFF20256B),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Organizado por ${widget.event.eventCreatorNickname}',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 10),
            const _EventLabel(),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.red),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'A solicitação será enviada à coordenação. As inscrições serão desabilitadas imediatamente, enquanto a decisão fica pendente de análise.',
                      textAlign: TextAlign.justify,
                      textWidthBasis: TextWidthBasis.parent,
                      style: TextStyle(
                        color: Color(0xFFE53935),
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Motivo do cancelamento',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  DropdownInputWidget(
                    inputHint: 'Selecione um motivo',
                    initialValue: controller.reasonController.text,
                    onSelectedItem: (value) {
                      controller.setReasonController(value);
                    },
                    items: const [
                      DropdownMenuItem(
                        value: 'Imprevisto',
                        child: Text('Imprevisto'),
                      ),
                      DropdownMenuItem(
                        value: 'Baixa adesão',
                        child: Text('Baixa adesão'),
                      ),
                      DropdownMenuItem(
                        value: 'outro',
                        child: Text('Outro'),
                      ),
                    ],
                  ),
  
                  const SizedBox(height: 14),
                  const Text(
                    'Detalhes (opcional)',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  CustomTextInput(
                    maxLines: 4,
                    hintText: "Conte mais detalhes sobre o cancelamento",
                    controller: controller.detailsController,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _SectionCard(
              color: const Color(0xFFFFF8E8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.mail_outline, color: Color(0xFFE39A17)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      eventValue > 0 
                          ? 'Após a aprovação, todos os inscritos serão comunicados por e-mail e receberão um ticket para informar a forma de reembolso, preferencialmente via PIX.'
                          : 'Após a aprovação, todos os inscritos serão comunicados por e-mail sobre o cancelamento.',
                      textAlign: TextAlign.center,
                      textWidthBasis: TextWidthBasis.parent,
                      style: const TextStyle(fontSize: 13, height: 1.35),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFEF2732),
                ),
                onPressed: () => _confirmCancellation(context),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Enviar solicitação de cancelamento'),
              ),
            ),
          ],
        );
      

        }, ),  

      ),
    );
  }

  Future<void> _confirmCancellation(BuildContext context) async {

    final profileController = context.read<ProfileController>();
    final eventValue = MaskFormatter.convertMoneyStringToDouble(widget.event.eventValue);

    final user = profileController.userProfile;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar solicitação?'),
        content: Text(
          eventValue > 0
              ? 'Você não poderá desistir do cancelamento após a confirmação. As inscrições serão desabilitadas imediatamente e os tickets de reembolso serão emitidos para cada participante inscrito.'
              : 'Você não poderá desistir do cancelamento após a confirmação. As inscrições serão desabilitadas imediatamente e os participantes serão notificados.',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Voltar'),
          ),
          FilledButton(
            onPressed: () => context.pop(true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmed == false || !context.mounted) return;

    final requesterId = user.uid;
    final requesterNickname = user.nickname;

    final controller = context.read<EventCancellationController>();
    final request = await controller.requestCancellation(
      event: widget.event,
      requesterId: requesterId,
      requesterNickname: requesterNickname,
    );

    if (!context.mounted) return;

    if (request == null) {
      final message = controller.errorMessage ?? 'Não foi possível enviar a solicitação.';
      AppMessageHandler.showError(context, message);
      return;
    }

    RouteController.redirectToCreatedEventsPage(context: context, redirectionMethod: RedirectionMethod.PUSH_REPLACEMENT);
  }
}

class _EventLabel extends StatelessWidget {
  const _EventLabel();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFECEBFF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Evento',
          style: TextStyle(
            color: Color(0xFF3927B8),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child, this.color = Colors.white});

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }
}
