import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/utils/message_handler.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sistema_abada_capoeira/features/event/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/presentation/controllers/event_cancellation_controller.dart';

class EventCancellationPage extends StatefulWidget {
  const EventCancellationPage({super.key, required this.event});

  final EventEntity event;

  @override
  State<EventCancellationPage> createState() => _EventCancellationPageState();
}

class _EventCancellationPageState extends State<EventCancellationPage> {
  final _detailsController = TextEditingController();
  String? _reason;

  @override
  void initState() {
    super.initState();
    _detailsController.addListener(_onDetailsChanged);
  }

  @override
  void dispose() {
    _detailsController.removeListener(_onDetailsChanged);
    _detailsController.dispose();
    super.dispose();
  }

  void _onDetailsChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: const Text('Cancelar evento'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                widget.event.imagePath,
                height: 138,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 138,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported, size: 40),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              widget.event.title,
              style: const TextStyle(
                color: Color(0xFF20256B),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Organizado por ${widget.event.organizer}',
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
                  DropdownButtonFormField<String>(
                    initialValue: _reason,
                    decoration: const InputDecoration(
                      labelText: 'Selecione um motivo',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'imprevisto',
                        child: Text('Imprevisto'),
                      ),
                      DropdownMenuItem(
                        value: 'baixa adesao',
                        child: Text('Baixa adesão'),
                      ),
                      DropdownMenuItem(value: 'outro', child: Text('Outro')),
                    ],
                    onChanged: (value) => setState(() => _reason = value),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Detalhes (opcional)',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Stack(
                    children: [
                      TextField(
                        controller: _detailsController,
                        maxLength: 300,
                        maxLines: 4,
                        buildCounter:
                            (
                              context, {
                              required currentLength,
                              required isFocused,
                              maxLength,
                            }) => null,
                        decoration: const InputDecoration(
                          hintText:
                              'Conte mais detalhes sobre o cancelamento...',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.fromLTRB(12, 12, 48, 28),
                        ),
                      ),
                      Positioned(
                        right: 12,
                        bottom: 8,
                        child: Text(
                          '${_detailsController.text.length}/300',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
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
                      widget.event.isPaid
                          ? 'Todos os inscritos serão comunicados por e-mail e receberão um ticket para informar a forma de reembolso, preferencialmente via PIX.'
                          : 'Todos os inscritos serão comunicados por e-mail sobre o cancelamento.',
                      textAlign: TextAlign.justify,
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
            const SizedBox(height: 10),
            SizedBox(
              height: 52,
              child: OutlinedButton(
                onPressed: () => context.pop(),
                child: const Text('Não cancelar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmCancellation(BuildContext context) async {
    if (_reason == null) {
      MessageHandler.showError(
        context,
        'Selecione um motivo para o cancelamento.',
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar solicitação?'),
        content: Text(
          widget.event.isPaid
              ? 'As inscrições serão desabilitadas imediatamente e ${widget.event.enrolledParticipants} ticket(s) de reembolso serão emitidos.'
              : 'As inscrições serão desabilitadas imediatamente e os participantes serão notificados.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Voltar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final requesterId = context.read<AuthController>().user?.uid;
    if (requesterId == null) {
      MessageHandler.showError(
        context,
        'É necessário estar autenticado para solicitar o cancelamento.',
      );
      return;
    }

    final controller = context.read<EventCancellationController>();
    final request = await controller.requestCancellation(
      event: widget.event,
      requesterId: requesterId,
      reason: _reason!,
      details: _detailsController.text.trim(),
    );
    if (!context.mounted) return;

    if (request == null) {
      final message =
          controller.errorMessage ?? 'Não foi possível enviar a solicitação.';
      MessageHandler.showError(context, message);
      return;
    }

    context.pop(
      widget.event.copyWith(
        cancellationRequested: true,
        registrationsEnabled: false,
      ),
    );
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
