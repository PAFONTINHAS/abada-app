import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/models/request_type.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/models/request_type_extension.dart';

class EventRequestCardWidget extends StatelessWidget {
  const EventRequestCardWidget({
    super.key,
    required this.requestType,
    required this.eventName,
  });

  final RequestType requestType;
  final String eventName;

  @override
  Widget build(BuildContext context) {
    RequestTypeExtension.checkRequestType(requestType);

    final String requestTypeText = RequestTypeExtension.requestTypeText;
    final Color requestTypeColor = RequestTypeExtension.requestTypeColor;
    final Color requestTypeBackgroundColor = RequestTypeExtension.requestTypeBackgroundColor;

    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 3, horizontal: 10),
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
            mainAxisSize: MainAxisSize.max,
            children: [
              
              Column(
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

                  SizedBox(height: 15),

                  Container(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(254, 241, 222, 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Em Análise",
                      style: TextStyle(
                        color: Color.fromRGBO(243, 136, 46, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 12
                      ),
                    ),
                  ),
                ],
              ),


              SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      eventName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    SizedBox(height: 10),

                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: requestTypeBackgroundColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        requestTypeText,
                        style: TextStyle(
                          color: requestTypeColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "26/06/2026, 10:30 - Curitiba/PR",
                      style: TextStyle(fontSize: 13),
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
