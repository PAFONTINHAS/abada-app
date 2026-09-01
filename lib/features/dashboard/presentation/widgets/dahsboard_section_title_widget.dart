import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';

class DahsboardSectionTitleWidget extends StatelessWidget {
  const DahsboardSectionTitleWidget({
    super.key,
    required this.sectionTitle,
    this.onPressed,
    this.onPressedTitle,
    this.itemsQuantity,
  });

  final String sectionTitle;
  final int? itemsQuantity;
  final String? onPressedTitle;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 15, horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            sectionTitle,
            style: const TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 17
            ),
          ),

          SizedBox(width: 10),

          if (itemsQuantity != null)
            Align(
              alignment: AlignmentGeometry.topStart,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: ColorConstants.indigoColor,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "$itemsQuantity",
                  style: const TextStyle(
                    color: ColorConstants.whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
          if(onPressed != null && onPressedTitle != null) ...[

            TextButton(
              onPressed: onPressed,
              child: RichText(
                text: TextSpan(
                  children: [

                    TextSpan(
                      text: onPressedTitle!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple
                      ),
                    ),

                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: const Icon(
                        Icons.chevron_right,
                        size: 18,
                        color: Colors.deepPurple,
                      ),
                    )
                  ]
                ),
              )
            ),
          ]
        ],
      ),
    );
  }
}
