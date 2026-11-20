import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/app_spacing.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/schedule_entity.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/class_form_controller.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/schedule_controller.dart';
import 'package:sistema_abada_capoeira/features/location/presentation/controllers/create_location_controller.dart';

class HeaderUnitNameWidget extends StatelessWidget {
  const HeaderUnitNameWidget({super.key});

  @override
  Widget build(BuildContext context) {

    final List<String> days = const [
      'Seg', 'Ter', 'Qua', 
      'Qui', 'Sex', 'Sáb', 'Dom'
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(28, 79, 39, 211),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: AppSpacing.symmetricH12V6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: AppSpacing.symmetricH12V6,
              child: Image.asset("assets/images/unit_icon.png", width: 80),
            ),

            Expanded(
              child: Column(
                children: [
                  Selector<ClassFormController, String>(
                    selector: (_, controller) =>
                        controller.classUnitController.text,
                    builder: (_, unitName, _) {
                      if (unitName.isEmpty) {
                        return Center(
                          child: Text(
                            "- UNIDADE -",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        );
                      }

                      return Center(
                        child: Text(
                          unitName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            overflow: TextOverflow.clip,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),


                  Selector<CreateLocationController, String>(
                    selector: (_, controller) => controller.fullAddress.text,
                    builder: (_, unitName, _) {
                      if (unitName.isEmpty) return SizedBox.shrink();

                      return Center(
                        child: Text(
                          unitName,
                          style: TextStyle(
                            fontSize: 12,
                            overflow: TextOverflow.clip,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),


                  Selector<ScheduleController, List<ScheduleEntity>>(
                    selector: (_, controller) => controller.scheduleList,
                    builder: (_, scheduleList, _) {
                      if (scheduleList.isEmpty) return SizedBox.shrink();

                      return SizedBox(
                        height: 50,
                        child: ListView.builder(
                          itemCount: scheduleList.length,
                          itemBuilder: (context, index) {
                            final schedule = scheduleList[index];

                            String scheduleDays = "";

                            for (final dayIndex in schedule.scheduleDays) {
                              scheduleDays += "${days[dayIndex]}, ";
                            }

                            final scheduleText =
                                "$scheduleDays - ${schedule.openingHour} às ${schedule.closingHour}";

                            return Center(
                              child: Text(
                                scheduleText,
                                style: TextStyle(
                                  fontSize: 12,
                                  overflow: TextOverflow.clip,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ) 
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
