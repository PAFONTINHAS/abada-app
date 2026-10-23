import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';

class RequestItemCard extends StatelessWidget {
  final EventRequestEntity request;
  final VoidCallback onViewEventDetails;
  final VoidCallback onViewRequestDetails;

  const RequestItemCard({
    super.key,
    required this.request,
    required this.onViewEventDetails,
    required this.onViewRequestDetails,
  });

  bool get _hasRequestDetails {
    return request.status == GenericRequestStatus.rejected ||
           request.status == GenericRequestStatus.changesRequested;
  }

  Color _getStatusBackgroundColor(GenericRequestStatus status) {
    switch (status) {
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

  Color _getStatusTextColor(GenericRequestStatus status) {
    switch (status) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorConstants.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorConstants.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  request.eventName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusBackgroundColor(request.status),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getStatusTextColor(request.status).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  request.status.portugueseName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _getStatusTextColor(request.status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 14, color: ColorConstants.textSecondary),
              const SizedBox(width: 6),
              Text(
                "${request.initDate.day}/${request.initDate.month}/${request.initDate.year} - ${request.endingDate.day}/${request.endingDate.month}/${request.endingDate.year}",
                style: const TextStyle(fontSize: 13, color: ColorConstants.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (_hasRequestDetails) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: onViewRequestDetails,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange.shade800,
                      side: BorderSide(color: Colors.orange.shade400),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Ver solicitação",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: ElevatedButton(
                  onPressed: onViewEventDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.indigoColor,
                    foregroundColor: ColorConstants.whiteColor,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Ver detalhes do evento",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}