import 'package:flutter/material.dart';

class MetricSummaryCardWidget extends StatelessWidget {
  const MetricSummaryCardWidget({
    super.key,
    required this.iconColor,
    required this.metricIcon,
    required this.metricValue,
    required this.metricDescription,
    required this.backgroundIconColor,
  });

  final IconData metricIcon;
  final String metricValue;
  final String metricDescription;
  final Color backgroundIconColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(

        padding: EdgeInsetsGeometry.all(10),
        child: Card(
          color: Color.fromRGBO(249, 249, 254, 100),
          child: Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 15, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: backgroundIconColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(metricIcon, color: iconColor, size: 30, fontWeight: FontWeight.bold,),
                ),

                SizedBox(height: 10),

                Text(metricValue, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),

                SizedBox(height: 5),

                Text(
                  metricDescription,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight(500)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )  
        ),

      ),
    );
  }
}
