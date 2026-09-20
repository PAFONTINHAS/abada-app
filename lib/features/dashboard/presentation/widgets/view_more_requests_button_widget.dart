import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/shared/clickable/clickable_widget.dart';

class ViewMoreRequestsButtonWidget extends StatelessWidget {
  const ViewMoreRequestsButtonWidget({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ClickableWidget(
      padding: EdgeInsetsGeometry.symmetric(vertical: 15),
      onTap: onPressed,
      child: Align(
        alignment: AlignmentGeometry.center,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text(
              "Ver todas as solicitações",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: ColorConstants.indigoColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
