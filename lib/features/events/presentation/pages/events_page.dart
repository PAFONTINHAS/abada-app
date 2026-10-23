import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/router/route_controller.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/shared/buttons/custom_text_button.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Página de Eventos"),) ,
      body: StandardScaffoldBodyWidget(child: Column(
        children: [

          CustomTextButton(text: "Criar Evento", onPressed: () => RouteController.redirectToCreateEventPage(context: context)),

          SizedBox(height: 20,),
          
          CustomTextButton(text: "Seus Eventos", onPressed: () => RouteController.redirectToCreatedEventsPage(context: context))



        ],
      )),
    );
  }
}