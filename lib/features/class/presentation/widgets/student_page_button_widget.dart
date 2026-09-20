import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/shared/clickable/clickable_widget.dart';

class StudentPageButtonWidget extends StatelessWidget {

  const StudentPageButtonWidget({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.buttonTitle,
    required this.buttonColor,
  });

  final IconData icon;
  final String buttonTitle;
  final VoidCallback onPressed;
  final Color buttonColor;

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Icon(icon, color: buttonColor,),         

                SizedBox(width: 5),

                Text(
                  buttonTitle,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: buttonColor,
                  ),
                ),
                
              ],
            ) 
          ),
        ),
      ),
    );
  }
}
