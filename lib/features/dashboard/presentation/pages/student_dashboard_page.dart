import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/dahsboard_section_title_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/dashboard_app_bar_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/event_card_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/user_event_subscription_card_widget.dart';

class StudentDashboardPage extends StatelessWidget {
  const StudentDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DashboardAppBarWidget(
        name: "João",
        roleOrGraduation: "Aluno • Corda Amarela",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              DahsboardSectionTitleWidget(
                sectionTitle: "Próximos eventos",
                onPressedTitle: "Ver todos",
                onPressed: () {},
              ),


              SizedBox(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: eventos.length,
                  itemBuilder: (context, index) {
                    final evento = eventos[index];

                    return EventCardWidget(
                      title: evento['title'],
                      dateTime: evento['dateTime'],
                      location: evento['location'],
                      price: evento['price'],
                      isFree: evento['isFree'],
                      imagePath: evento['imagePath'],
                      onTap: evento['onTap'],
                    );
                  },
                ),
              ),

              DahsboardSectionTitleWidget(
                sectionTitle: "Minhas Inscrições",
                onPressedTitle: "Ver todas",
                onPressed: () {},
              ),

              UserEventSubscriptionCardWidget(eventName: "Batizado e Troca de Crodas 2026", subscriptionConfirmed: true),
              UserEventSubscriptionCardWidget(eventName: "Workshop de Maculelê", subscriptionConfirmed: true),
              UserEventSubscriptionCardWidget(eventName: "Troca de Cordas Infantil", subscriptionConfirmed: false),




              


            ],
          ),
        ),
      ),
    );
  }
}



  List<Map<String, dynamic>> eventos = [

    {
      'title': 'Batizado e Troca de Cordas 2026',
      'dateTime': '10/08/2026 - 09:00',
      'location': 'Curitiba - PR',
      'price': 'Gratuito',
      'isFree': true,
      'imagePath': 'assets/images/capoeira_event_image.jpg',
      'onTap': () { LoggingService.displayInfo("Me clicaram aqui hein!");}
    },
    {
      'title': 'Batizado e Troca de Cordas 2026',
      'dateTime': '10/08/2026 - 09:00',
      'location': 'Curitiba - PR',
      'price': 'R\$ 60,00',
      'isFree': false,
      'imagePath': 'assets/images/capoeira_event_image.jpg',
      'onTap': () { LoggingService.displayInfo("Me clicaram aqui hein!");}
    },
    {
      'title': 'Batizado e Troca de Cordas 2026',
      'dateTime': '10/08/2026 - 09:00',
      'location': 'Curitiba - PR',
      'price': 'Gratuito',
      'isFree': true,
      'imagePath': 'assets/images/capoeira_event_image.jpg',
      'onTap': () { LoggingService.displayInfo("Me clicaram aqui hein!");}
    },
    {
      'title': 'Batizado e Troca de Cordas 2026',
      'dateTime': '10/08/2026 - 09:00',
      'location': 'Curitiba - PR',
      'price': 'Gratuito',
      'isFree': true,
      'imagePath': 'assets/images/capoeira_event_image.jpg',
      'onTap': () { LoggingService.displayInfo("Me clicaram aqui hein!");}
    },
    {
      'title': 'Batizado e Troca de Cordas 2026',
      'dateTime': '10/08/2026 - 09:00',
      'location': 'Curitiba - PR',
      'price': 'Gratuito',
      'isFree': true,
      'imagePath': 'assets/images/capoeira_event_image.jpg',
      'onTap': () { LoggingService.displayInfo("Me clicaram aqui hein!");}
    },
  ] ;