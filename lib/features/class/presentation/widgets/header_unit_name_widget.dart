import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/app_spacing.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/create_or_edit_class_controller.dart';

class HeaderUnitNameWidget extends StatelessWidget {
  const HeaderUnitNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: Selector<CreateOrEditClassController, String>(
                selector: (_, controller) => controller.classUnitController.text,
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
            ),
          ],
        ),
      ),
    );
  }
}
