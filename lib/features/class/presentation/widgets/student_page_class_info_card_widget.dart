import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/router/route_controller.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/schedule_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';

class StudentPageClassInfoCardWidget extends StatelessWidget {
  const StudentPageClassInfoCardWidget({
    super.key,
    required this.classEntity
  });

  
  final ClassEntity classEntity;

  @override
  Widget build(BuildContext context) {

    final classLocation = "${classEntity.location}, ${classEntity.city} - ${classEntity.state}, ${classEntity.cep}";

    final profileController = context.read<ProfileController>();
    final bool userIsProfessor =
        profileController.userProfile.uid == classEntity.professor.professorId;

    String classSchedule = "";
    for (final schedule in classEntity.schedule){
      classSchedule += "$schedule\n";
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11.0), // Levemente menor que a borda externa
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 120,
              decoration:  BoxDecoration(
                color: Color(0xFF2B2073), // Cor de fundo caso a imagem demore a carregar
              ),
            ),
            
            // CONTEÚDO DO CARD
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título e Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                       Expanded(
                        child: Text(
                          classEntity.unitName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      // Container(
                      //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      //   decoration: BoxDecoration(
                      //     color: Colors.green.shade50,
                      //     borderRadius: BorderRadius.circular(16),
                      //   ),
                      //   child: const Text(
                      //     'Ativa',
                      //     style: TextStyle(
                      //       color: Colors.green,
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 12,
                      //     ),
                      //   ),
                      // ),

                      if (userIsProfessor)
                        TextButton(
                          onPressed: () =>
                              RouteController.redirectToEditClassPage(
                                context: context,
                                classEntity: classEntity,
                              ),
                          child: Row(
                            children: [Icon(Icons.edit), Text("Editar")],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Informações em lista
                  _buildScheduleWidget(Icons.access_time, classEntity.schedule),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.location_on_outlined, classLocation),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.person_outline, "Responsável: ${classEntity.professor.professorNickname}"),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.people_outline, '${classEntity.members.length} alunos'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.black87),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleWidget(
    IconData icon,
    List<ScheduleEntity> scheduleList,
  ) {
    final List<String> weekDays = const [
      'Seg', 'Ter', 'Qua', 'Qui',
      'Sex', 'Sáb', 'Dom',
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.black87),
        const SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            height: classEntity.schedule.length * 20,
            child: ListView.builder(
              itemCount: classEntity.schedule.length,
              itemBuilder: (context, index) {
                final schedule = classEntity.schedule[index];

                final openingHour = schedule.openingHour;
                final closingHour = schedule.closingHour;
                String days = "";

                for (int i = 0; i < schedule.scheduleDays.length; i++) {
                  days += weekDays[schedule.scheduleDays[i]];

                  if (i != schedule.scheduleDays.length - 1) {
                    days += ", ";
                  }
                }

                return Text(
                  "$days - $openingHour às $closingHour",
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}