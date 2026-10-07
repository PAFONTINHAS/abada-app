import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/widgets/class_location_card_widget.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/widgets/location_radius_selection_widget.dart';
import 'package:sistema_abada_capoeira/features/location/presentation/controllers/student_class_selection_controller.dart';

class ClassesLocationListWidget extends StatelessWidget {
  const ClassesLocationListWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(

      children: [

        const LocationRadiusSelectionWidget(),
        SizedBox(
          height: 300,
          child: Consumer<StudentClassSelectionController>(
            builder: (context, controller, child) {
              if (controller.isLoadingLocations) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.locations.isEmpty) {
                return const Center(
                  child: Text(
                    "Nenhuma unidade encontrada no raio selecionado.",
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: controller.locations.length,
                itemBuilder: (context, index) {
                  final location = controller.locations[index];

                  final isSelected =
                      controller.selectedLocationId == location.id;

                  return ClassLocationCardWidget(
                    isSelected: isSelected,
                    location: location,
                    controller: controller,
                  );
                },
              );
            },
          ),
        )
      ],
    );
    
  }
}
