import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/router/route_controller.dart';
import 'package:sistema_abada_capoeira/core/utils/date_formatter.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/tusca_entity.dart';
import 'package:sistema_abada_capoeira/shared/clickable/clickable_widget.dart';

class TuscaBadgeCardWidget extends StatelessWidget {
  const TuscaBadgeCardWidget({super.key, required this.tuscaEntity});

  final TuscaEntity tuscaEntity;

  @override
  Widget build(BuildContext context) {

    final tuscaBadgeImage = tuscaEntity.isRegularTusca
      ? "regular_tusca_badge.png"
      : "irregular_tusca_badge.png";

    final statusLabel = tuscaEntity.isRegularTusca
      ? "REGULAR"
      : "IRREGULAR";

    final statusColor = tuscaEntity.isRegularTusca ? Colors.green : Colors.red;

    return ClickableWidget(
      padding: EdgeInsetsGeometry.symmetric(vertical: 3, horizontal: 10),
      onTap: () => RouteController.redirectToProfilePage(context: context),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          children: [
            Image.asset("assets/images/$tuscaBadgeImage", width: 90),

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
                          color: statusColor,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: Text(
                          statusLabel,
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

                  if(tuscaEntity.isRegularTusca)
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Válido até ",
                            style: TextStyle(color: Colors.black, fontSize: 13),
                          ),

                          TextSpan(
                            text: DateFormatter.formatDDMMYYYY(tuscaEntity.validUntil),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
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
    );
  }
}
