import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/shared/class_location_list_widget/class_location_card_widget.dart';
import 'package:sistema_abada_capoeira/shared/class_location_list_widget/location_radius_selection_widget.dart';
import 'package:sistema_abada_capoeira/features/location/presentation/controllers/student_class_selection_controller.dart';

class ClassesLocationListWidget extends StatelessWidget {
  const ClassesLocationListWidget({super.key, this.currentClassEntityId});
  
  final String? currentClassEntityId;

  @override
  Widget build(BuildContext context) {

    return Column(

      children: [

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              const LocationRadiusSelectionWidget(),
              const SizedBox(height: 12),
              
              // Filtro Visual por Bairro (Apenas Interface)
              TextField(
                decoration: InputDecoration(
                  hintText: 'Filtrar por bairro...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.filter_list_rounded),
                    onPressed: () {}, // Apenas visual por enquanto
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12, 
                    horizontal: 16,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),
        
        SizedBox(
          height: 300,
          child: Consumer<StudentClassSelectionController>(
            builder: (context, controller, child) {
              if (controller.isLoadingLocations) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.locations.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_off_outlined,
                          size: 48,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Nenhuma unidade encontrada no raio selecionado.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: controller.locations.length,
                itemBuilder: (context, index) {
                  final location = controller.locations[index];
                  final isSelected = controller.selectedLocationId == location.id;


                  return ClassLocationCardWidget(
                    isSelected: isSelected,
                    location: location,
                    controller: controller,
                    currentClassEntityId: currentClassEntityId,
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
