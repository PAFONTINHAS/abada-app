import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/models/location.dart';

  // --------------------------------------------//
 //    WIDGET DE NAVEGAÇÃO ENTRE PÁGINAS.       //
// --------------------------------------------//


class LocationSlider extends StatefulWidget {
  final String uid;
  const LocationSlider({super.key, required this.uid});
  @override
  // _LocationSlider createState() => _LocationSlider();
  State<LocationSlider> createState() => _LocationSlider();
}

class _LocationSlider extends State<LocationSlider> {
  @override
  Widget build(BuildContext context) {


    List<Location> locations = [
      // Location(
      //   address: "Home",
      //   imagePath: "assets/icon1.png",
      //   action: 0,
      // ),
      Location(
        address: "Cultivos",
        // imagePath: "assets/icon1.png",
        action: 1,
      ),
      Location(
        address: "EVA Ensina",
        // imagePath: "assets/icon2.png",
        action: 2,
      ),
      Location(
        address: "Suporte",
        // imagePath: "assets/icon3.png",
        action: 3,
      ),
      Location(
        address: "Perfil",
        // imagePath: "assets/icon6.png",
        action: 4,
      ),
    ];
    const SizedBox(height: 140.0);

    // return Container(
    //   height: ScreenUtil().setHeight(140.0),
      ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () async {
              switch (locations[index].action) {
                case 1:
                  // RouteController.redirectToAmbientesHomepage(context: context);
                break;
                case 2:
                  // RouteController.redirectToEnsinoPage(context: context);
                break;
                case 3:
                  // RouteController.redirectToSupportPage(context: context);
                break;
                case 4:
                  // RouteController.redirectToProfilePage(context: context);
                break;
              }
            },
            child: Container(
              // width: ().setWidth(120.0),
              decoration: BoxDecoration(
                color: locations[index].color,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  const BoxShadow(
                    color: Color.fromRGBO(169, 176, 185, 0.42),
                    spreadRadius: 0,
                    blurRadius: 8.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 12.0,
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 5,
                    top: 30.0,
                    child: Image(image: AssetImage(locations[index].imagePath!), height: 47.0,),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${locations[index].address}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: "Sofia",
                            height: 1.5,
                            fontSize: 17.0,
                          ),
                        ),
                        // TextSpan(
                        //   text: locations[index].state,
                        //   style: TextStyle(
                        //     fontSize: 16.0,
                        //   ),
                        // )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(width: 15.0,);
        },
        itemCount: locations.length,
      );
    // );

    return const CircularProgressIndicator.adaptive();
  }
}
