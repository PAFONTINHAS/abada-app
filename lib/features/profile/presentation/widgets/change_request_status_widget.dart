import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/profile_change_request_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/repository/profile_repository.dart';

class ChangeRequestStatusWidget extends StatefulWidget {
  const ChangeRequestStatusWidget({super.key});

  @override
  State<ChangeRequestStatusWidget> createState() => _ChangeRequestStatusWidgetState();
}

class _ChangeRequestStatusWidgetState extends State<ChangeRequestStatusWidget> {
  bool _loading = true;
  ProfileChangeRequestEntity? _latestRequest;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    try {
      final requests = await context.read<ProfileRepository>().getMyChangeRequests();
      if (!mounted) return;

      setState(() {
        _latestRequest = requests.isEmpty ? null : requests.first;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    final request = _latestRequest;
    if (request == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F3FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE7E2FF)),
        ),
        child: const Text(
          'Nenhuma solicitação de alteração registrada até o momento.',
          style: TextStyle(color: Color(0xFF5B4A8A), fontWeight: FontWeight.w600),
        ),
      );
    }

    final label = _statusLabel(request);
    final color = _statusColor(request);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withAlpha((255 * 0.12).round()),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha((255 * 0.5).round())),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status da solicitação',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          if (request.newBelt != null || request.newNickname != null) ...[
            const SizedBox(height: 6),
            Text(
              _changesSummary(request),
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ],
      ),
    );
  }

  String _statusLabel(ProfileChangeRequestEntity request) {
    if (request.isPending) return 'Sua solicitação está em análise.';
    if (request.isApproved) return 'Sua solicitação foi aprovada.';
    if (request.isRejected) return 'Sua solicitação foi rejeitada.';
    return 'Status da solicitação indisponível.';
  }

  Color _statusColor(ProfileChangeRequestEntity request) {
    if (request.isPending) return const Color(0xFFB56A00);
    if (request.isApproved) return const Color(0xFF1E7F5A);
    if (request.isRejected) return const Color(0xFFB3261E);
    return Colors.grey;
  }

  String _changesSummary(ProfileChangeRequestEntity request) {
    final pieces = <String>[];
    if (request.newNickname != null && request.newNickname!.trim().isNotEmpty) {
      pieces.add('apelido: ${request.newNickname}');
    }
    if (request.newBelt != null && request.newBelt!.trim().isNotEmpty) {
      pieces.add('corda: ${request.newBelt}');
    }
    return pieces.isEmpty ? 'Sem alterações pendentes.' : 'Solicitação para ${pieces.join(' e ')}.';
  }
}
