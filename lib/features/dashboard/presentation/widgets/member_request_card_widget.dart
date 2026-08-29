import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';

class MemberRequestCardWidget extends StatelessWidget {
  const MemberRequestCardWidget({super.key});

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
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.amber,
                      ),

                      child: Image.asset(
                        "assets/images/capoeira_member_profile_picture.png",
                        width: 80,
                      ),
                    ),

                    SizedBox(width: 10),

                    Expanded(
                      child: Column( 
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pedro Henrique",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),

                          Text("Unidade Centro"),

                          Text("Solicitado em 26/06/2026, 10:30"),
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
