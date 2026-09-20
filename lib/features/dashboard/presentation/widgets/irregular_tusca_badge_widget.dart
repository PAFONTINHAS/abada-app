import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/shared/clickable/clickable_widget.dart';

class IrregularTuscaBadgeWidget extends StatelessWidget {
  const IrregularTuscaBadgeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ClickableWidget(
      padding: EdgeInsetsGeometry.symmetric(vertical: 3, horizontal: 10),
      onTap: () {},
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            children: [
              Image.asset("assets/images/irregular_tusca_badge.png", width: 90),

              SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "TUSCA",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),

                        SizedBox(width: 5),

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),

                          child: Text(
                            "IRREGULAR",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 5),

                    Text(
                      "Esteja regular com a TUSCA",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(Icons.chevron_right, size: 35),
            ],
          ),
        ),
      ),
    );
  }
}
