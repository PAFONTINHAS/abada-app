import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/request_changes_dialog_controller.dart';

class RequestChangesHeaderWidget extends StatelessWidget {
  const RequestChangesHeaderWidget({
    super.key,
  });

  static const Color orange = Color(0xFFF59E0B);
  static const Color darkText = Color(0xFF252334);
  static const Color secondaryText = Color(0xFF6B6877);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF4DD),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.edit_outlined,
            color: orange,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Pedir correções',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: darkText,
            ),
          ),
        ),
        Selector<RequestChangesDialogController, bool>(
          selector: (_, controller) =>
              controller.isLoading,
          builder: (context, isLoading, child) {
            return IconButton(
              onPressed: isLoading
                  ? null
                  : () {
                      Navigator.of(context).pop();
                    },
              icon: const Icon(
                Icons.close,
                size: 21,
              ),
              color: secondaryText,
            );
          },
        ),
      ],
    );
  }
}