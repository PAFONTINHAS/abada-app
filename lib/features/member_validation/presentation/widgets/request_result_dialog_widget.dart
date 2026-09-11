import 'package:flutter/material.dart';

import '../controllers/request_result_controller.dart';
import '../models/request_result_type.dart';

class RequestResultDialogWidget  extends StatelessWidget {
  final RequestResultType type;

  const RequestResultDialogWidget ({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final controller = RequestResultController();
    final resultData = controller.getResultData(type);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: resultData.backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                resultData.icon,
                color: resultData.iconColor,
                size: 32,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              resultData.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              resultData.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Entendi'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}