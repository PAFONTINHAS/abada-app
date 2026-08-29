import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';

class DahsboardSectionTitleWidget extends StatelessWidget {
  const DahsboardSectionTitleWidget({super.key, required this.sectionTitle, this.itemsQuantity});

  final String sectionTitle;
  final int? itemsQuantity;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          sectionTitle,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),

        SizedBox(width: 10),
        
        if(itemsQuantity != null)
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ColorConstants.indigoColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              "$itemsQuantity",
              style: TextStyle(
                color: ColorConstants.whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

      ],
    );
  }
}