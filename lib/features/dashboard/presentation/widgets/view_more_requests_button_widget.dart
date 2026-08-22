import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';

class ViewMoreRequestsButtonWidget extends StatelessWidget {
  const ViewMoreRequestsButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentGeometry.center,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            border: BoxBorder.all(width: 0.3, color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
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
