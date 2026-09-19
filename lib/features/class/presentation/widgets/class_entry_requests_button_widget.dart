import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/member_validation/presentation/controllers/membership_validation_controller.dart';
import 'package:sistema_abada_capoeira/shared/clickable/clickable_widget.dart';

class ClassEntryRequestsButtonWidget extends StatelessWidget {
  const ClassEntryRequestsButtonWidget({super.key, required this.onPressed});

  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {

    final MembershipValidationController membershipValidationController = context.read<MembershipValidationController>();

    return Stack(
      children: [
        ClickableWidget(
          padding: EdgeInsets.all(10),
          color: ColorConstants.indigoColor,
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Solicitações de entrada',
                  style: TextStyle(
                    color: ColorConstants.whiteColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        Positioned(
          top: -2,
          right: 3,
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Text(
              "${membershipValidationController.requests.length}",
              style: TextStyle(
                color: ColorConstants.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
