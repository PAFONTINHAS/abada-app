import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';

class RegularTuscaBadgeWidget extends StatelessWidget {
  const RegularTuscaBadgeWidget({super.key});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 3, horizontal: 10),
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color: ColorConstants.whiteColor,
                  border: BoxBorder.all(color: Colors.black, width: 0.3),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  children: [

                    Image.asset(
                      "assets/images/regular_tusca_badge.png",
                      width: 100,
                    ),

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
                                  color: const Color.fromARGB(255, 76, 175, 79),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                padding: EdgeInsets.all(5),

                                child: Text(
                                  "REGULAR",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              )
                            ],
                          ),         

                          SizedBox(height: 5),          


                          RichText(
                            text: TextSpan(
                              children: [

                                TextSpan(
                                  text: "Válido até ",
                                  style: TextStyle(color: Colors.black),
                                ),

                                TextSpan(
                                  text: "07/08/2028",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ]
                            ),
                          )       

                        ],
                      ),
                    ),

                    Icon(Icons.chevron_right, size: 35),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
