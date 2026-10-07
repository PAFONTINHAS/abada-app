import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/features/location/presentation/controllers/student_class_selection_controller.dart';

class LocationRadiusSelectionWidget extends StatelessWidget {
  const LocationRadiusSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final locationController = context.watch<StudentClassSelectionController>();
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.4),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.near_me_outlined,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                "Raio de busca",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: locationController.searchRadiusKm,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: theme.colorScheme.primary,
              ),
              borderRadius: BorderRadius.circular(12),
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
          ),
        ],
      ),
    );
  }
}