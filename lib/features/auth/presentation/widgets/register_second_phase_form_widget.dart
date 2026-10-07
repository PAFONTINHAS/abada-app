import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/custom_text_input.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/register_form_controller.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/widgets/classes_location_list_widget.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/student_class_selection_controller.dart';

class RegisterSecondPhaseFormWidget extends StatefulWidget {
  const RegisterSecondPhaseFormWidget({super.key});

  @override
  State<RegisterSecondPhaseFormWidget> createState() => _RegisterSecondPhaseFormWidgetState();
}

class _RegisterSecondPhaseFormWidgetState extends State<RegisterSecondPhaseFormWidget> {
  // @override
  // void initState() {
  //   super.initState();

  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     final controller = context.read<StudentClassSelectionController>();

  //     controller.initNearbyLocations();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final formController = context.watch<RegisterFormController>();
    final locationController = context.watch<StudentClassSelectionController>();

    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            "Mais Informações",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),

        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Complete seus dados para finalizar o cadastro",
              style: TextStyle(fontSize: 17),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        CustomTextInput(
          label: "Apelido",
          prefixIcon: Icon(Icons.person_2_outlined),
          hintText: "Digite seu apelido",
          controller: formController.nicknameController,
        ),

        SizedBox(height: 15),

        CustomTextInput(
          label: "Corda",
          prefixIcon: Icon(Icons.linear_scale),
          hintText: "Digite sua corda",
          controller: formController.beltController,
        ),

        SizedBox(height: 15),

        Padding(
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
        ),

        ClassesLocationListWidget(),
      ],
    );
  }


}
