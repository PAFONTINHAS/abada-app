import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/acess_profile.dart';
import 'package:sistema_abada_capoeira/features/event/domain/entities/event_entity.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  EventEntity _event = EventEntity(
    id: 'batizado-troca-cordas-2026',
    title: 'Batizado e Troca de Cordas 2026',
    organizer: 'Abadá Capoeira Centro',
    dateTime: DateTime(2026, 8, 10, 9),
    location: 'Curitiba - PR',
    imagePath: 'assets/images/capoeira_event_image.jpg',
    isPaid: true,
    enrolledParticipants: 24,
  );

  @override
  Widget build(BuildContext context) {
    final role = context.watch<AuthController>().userRole;
    final canRequestCancellation = role == UserRole.professor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos'),
        actions: [
          if (_event.cancellationRequested)
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.hourglass_top, color: Color(0xFFE39A17)),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              _event.imagePath,
              height: 190,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 190,
                color: Colors.grey.shade200,
                child: const Icon(Icons.image_not_supported, size: 48),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _event.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text('Organizado por ${_event.organizer}'),
          const SizedBox(height: 16),
          _InfoTile(
            icon: Icons.calendar_today_outlined,
            text: '10/08/2026 às 09:00',
          ),
          _InfoTile(icon: Icons.location_on_outlined, text: _event.location),
          _InfoTile(
            icon: Icons.people_outline,
            text: '${_event.enrolledParticipants} inscritos',
          ),
          const SizedBox(height: 12),
          if (canRequestCancellation && !_event.cancellationRequested)
            _CancelEventButton(onPressed: () => _openCancellationPage(context)),
          if (_event.cancellationRequested)
            _StatusBanner(
              color: const Color(0xFFFFF4DE),
              icon: Icons.hourglass_top,
              text: _event.refundTickets.isEmpty
                  ? 'Cancelamento solicitado e enviado à coordenação. Inscrições desabilitadas.'
                  : 'Cancelamento solicitado. ${_event.refundTickets.length} '
                        'tickets de reembolso emitidos.',
            ),
          if (!_event.registrationsEnabled)
            const _StatusBanner(
              color: Color(0xFFFFF4DE),
              icon: Icons.lock_outline,
              text:
                  'Inscrições desabilitadas enquanto a solicitação é analisada.',
            ),
        ],
      ),
    );
  }

  Future<void> _openCancellationPage(BuildContext context) async {
    final updatedEvent = await context.push<EventEntity>(
      '/events/cancel',
      extra: _event,
    );
    if (!mounted || updatedEvent == null) return;
    setState(() => _event = updatedEvent);
  }
}

class _CancelEventButton extends StatelessWidget {
  const _CancelEventButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton.icon(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFEF2732),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        icon: const Icon(Icons.delete_outline, size: 19),
        label: const Text(
          'Cancelar',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF4E27D3)),
          const SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({
    required this.color,
    required this.icon,
    required this.text,
  });

  final Color color;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.justify,
              textWidthBasis: TextWidthBasis.parent,
              style: const TextStyle(fontSize: 13, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
