import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/features/location/presentation/controllers/student_class_selection_controller.dart';

class LocationRadiusSelectionWidget extends StatelessWidget {
  const LocationRadiusSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final locationController = context.watch<StudentClassSelectionController>();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const Text("Raio de busca: "),
          DropdownButton<int>(
            value: locationController.searchRadiusKm,
            items: const [
              DropdownMenuItem(value: 5, child: Text("5 km")),
              DropdownMenuItem(value: 10, child: Text("10 km")),
              DropdownMenuItem(value: 20, child: Text("20 km")),
              DropdownMenuItem(value: 50, child: Text("50 km")),
            ],
            onChanged: (radius) {
              if (radius != null) locationController.updateRadius(radius);
            },
          ),
        ],
      ),
    );
  }
}
