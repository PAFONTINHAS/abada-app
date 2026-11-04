import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_subscription_entity.dart';

class EventQrCodeWidget extends StatelessWidget {
  const EventQrCodeWidget({super.key, required this.subscription});

  final EventSubscriptionEntity subscription;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text(
            "Apresente este QR Code na entrada",
            style: TextStyle(fontSize: 14, color: ColorConstants.textSecondary),
          ),
          const SizedBox(height: 16),

          // Geração do QR Code baseado no verificationCode
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ColorConstants.borderColor),
            ),
            child: QrImageView(
              data: subscription.verificationCode,
              version: QrVersions.auto,
              size: 200.0,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: ColorConstants.textPrimary,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: ColorConstants.textPrimary,
              ),
            ),
          ),

          const SizedBox(height: 16),
          Text(
            subscription.verificationCode,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: ColorConstants.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
