import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';

class EventStatusCardWidget extends StatelessWidget {
  final dynamic item; // Aceita EventEntity ou EventRequestEntity
  final VoidCallback onViewEventDetails;
  final VoidCallback? onViewRequestDetails; // Usado apenas para solicitações (requests)

  const EventStatusCardWidget({
    super.key,
    required this.item,
    required this.onViewEventDetails,
    this.onViewRequestDetails,
  });

  bool get _isRequest => item is EventRequestEntity;
  bool get _isEvent => item is EventEntity;

  String get _eventName => _isRequest ? item.eventName : item.eventName;
  DateTime get _initDate => _isRequest ? item.initDate : item.eventInitDate;
  DateTime get _endingDate => _isRequest ? item.endingDate : item.eventEndingDate;

  // Extração segura de dados caso seja um EventEntity completo
  String? get _imagePath => _isEvent ? (item as EventEntity).eventImagePath : null;
  String? get _location => _isEvent ? "${(item as EventEntity).city} - ${(item as EventEntity).state}" : null;
  String? get _description => _isEvent ? (item as EventEntity).eventDescription : null;

  String get _statusName {
    if (_isRequest) return (item as EventRequestEntity).status.portugueseName;
    if (_isEvent) return (item as EventEntity).finishedEvent ? "Finalizado" : "Aprovado";
    return "Desconhecido";
  }

  bool get _hasRequestDetails {
    if (!_isRequest) return false;
    final status = (item as EventRequestEntity).status;
    return status == GenericRequestStatus.rejected || status == GenericRequestStatus.changesRequested;
  }

  Color _getStatusBackgroundColor() {
    if (_isRequest) {
      switch ((item as EventRequestEntity).status) {
        case GenericRequestStatus.rejected:
          return Colors.red.shade50;
        case GenericRequestStatus.changesRequested:
          return Colors.orange.shade50;
        case GenericRequestStatus.requested:
        case GenericRequestStatus.updated:
          return Colors.amber.shade50;
        default:
          return Colors.grey.shade100;
      }
    }
    if (_isEvent) {
      return (item as EventEntity).finishedEvent ? Colors.blueGrey.shade700 : Colors.green.shade50;
    }
    return Colors.grey.shade100;
  }

  Color _getStatusTextColor() {
    if (_isRequest) {
      switch ((item as EventRequestEntity).status) {
        case GenericRequestStatus.rejected:
          return Colors.red.shade800;
        case GenericRequestStatus.changesRequested:
          return Colors.orange.shade800;
        case GenericRequestStatus.requested:
        case GenericRequestStatus.updated:
          return Colors.amber.shade900;
        default:
          return ColorConstants.textSecondary;
      }
    }
    if (_isEvent) {
      return (item as EventEntity).finishedEvent ? Colors.white : Colors.green.shade800;
    }
    return ColorConstants.textSecondary;
  }

  IconData _getStatusIcon() {
    if (_isRequest) {
      switch ((item as EventRequestEntity).status) {
        case GenericRequestStatus.rejected:
          return Icons.cancel_outlined;
        case GenericRequestStatus.changesRequested:
          return Icons.edit_note_outlined;
        case GenericRequestStatus.approved:
          return Icons.check_circle_outline;
        default:
          return Icons.hourglass_empty;
      }
    }
    return (item as EventEntity).finishedEvent ? Icons.flag_outlined : Icons.check_circle_outline;
  }

  String _formatEventDate(DateTime start, DateTime end) {
    final startDay = start.day.toString().padLeft(2, '0');
    final startMonth = start.month.toString().padLeft(2, '0');
    final startYear = start.year.toString();
    final startHour = start.hour.toString().padLeft(2, '0');
    final startMin = start.minute.toString().padLeft(2, '0');

    final endDay = end.day.toString().padLeft(2, '0');
    final endMonth = end.month.toString().padLeft(2, '0');
    final endYear = end.year.toString();
    final endHour = end.hour.toString().padLeft(2, '0');
    final endMin = end.minute.toString().padLeft(2, '0');

    if (startYear == endYear && startMonth == endMonth && startDay == endDay) {
      return '$startDay/$startMonth/$startYear - $startHour:$startMin até $endHour:$endMin';
    } else {
      return 'de $startDay/$startMonth/$startYear, $startHour:$startMin até $endDay/$endMonth/$endYear, $endHour:$endMin';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isRequest && !_isEvent) return const SizedBox.shrink();

    final bgColor = _getStatusBackgroundColor();
    final textColor = _getStatusTextColor();
    final borderColor = _isEvent && (item as EventEntity).finishedEvent 
        ? Colors.blueGrey.shade700.withOpacity(0.3) 
        : textColor.withOpacity(0.3);

    return Container(
      decoration: BoxDecoration(
        color: ColorConstants.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorConstants.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [          
          // 2. Corpo do Card
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tag de Status do Evento/Solicitação
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_getStatusIcon(), size: 12, color: textColor),
                      const SizedBox(width: 6),
                      Text(
                        _statusName.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Título
                Text(
                  _eventName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),

                // Descrição Opcional
                if (_description != null && _description!.isNotEmpty) ...[
                  Text(
                    _description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: ColorConstants.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Localização Opcional
                if (_location != null && _location!.isNotEmpty) ...[
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: ColorConstants.textSecondary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _location!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: ColorConstants.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                ] else ...[
                  const SizedBox(height: 8),
                ],

                // Data Inteligente
                Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined, size: 14, color: ColorConstants.textSecondary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _formatEventDate(_initDate, _endingDate),
                        style: const TextStyle(fontSize: 12, color: ColorConstants.textSecondary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Botões de Ação
                Row(
                  children: [
                    if (_hasRequestDetails && onViewRequestDetails != null) ...[
                      Expanded(
                        flex: 4,
                        child: OutlinedButton(
                          onPressed: onViewRequestDetails,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.orange.shade800,
                            side: BorderSide(color: Colors.orange.shade400),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Ver motivo",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      flex: 6,
                      child: ElevatedButton(
                        onPressed: onViewEventDetails,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstants.indigoColor,
                          foregroundColor: ColorConstants.whiteColor,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Detalhes do evento",
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}