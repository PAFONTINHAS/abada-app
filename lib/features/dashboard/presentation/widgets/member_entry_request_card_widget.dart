import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';

class MemberEntryRequestCardWidget extends StatelessWidget {
  const MemberEntryRequestCardWidget({super.key});

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
                        width: 70,
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
                              fontSize: 15,
                            ),
                          ),

                          Text("Unidade Centro", style: TextStyle(fontSize: 13),),

                          Text("Solicitado em 26/06/2026, 10:30", style: TextStyle(fontSize: 13),),
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
