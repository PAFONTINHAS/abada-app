import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/register_form_controller.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/student_class_selection_controller.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/custom_text_input.dart';

class RegisterSecondPhaseFormWidget extends StatefulWidget {
  const RegisterSecondPhaseFormWidget({super.key});

  @override
  State<RegisterSecondPhaseFormWidget> createState() =>
      _RegisterSecondPhaseFormWidgetState();
}

class _RegisterSecondPhaseFormWidgetState
    extends State<RegisterSecondPhaseFormWidget> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<StudentClassSelectionController>();

      controller.initNearbyLocations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final formController = context.read<RegisterFormController>();
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

        SizedBox(
          height: 300,
          child: locationController.isLoadingLocations
              ? const Center(child: CircularProgressIndicator())
              : StreamBuilder<List<DocumentSnapshot>>(
                  stream: locationController.nearbyLocationsStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final locations = snapshot.data ?? [];

                    if (locations.isEmpty) {
                      return const Center(
                        child: Text(
                          "Nenhuma academia encontrada no raio selecionado.",
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: locations.length,
                      itemBuilder: (context, index) {
                        final locationDoc = locations[index];
                        final data = locationDoc.data() as Map<String, dynamic>;
                        final isSelected =
                            locationController.selectedLocationId ==
                            locationDoc.id;

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          color: isSelected
                              ? Colors.indigo.shade50
                              : Colors.white,
                          child: ExpansionTile(
                            title: Text(
                              data['name'] ?? 'Academia sem nome',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(data['address'] ?? ''),
                            onExpansionChanged: (expanded) {
                              if (expanded) {
                                locationController.selectLocation(
                                  locationDoc.id,
                                );
                              }
                            },
                            children: [
                              // Stream de Turmas dentro da Academia selecionada
                              if (isSelected &&
                                  locationController.classesStream != null)
                                StreamBuilder<QuerySnapshot>(
                                  stream: locationController.classesStream,
                                  builder: (context, classSnapshot) {
                                    if (classSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    final classes =
                                        classSnapshot.data?.docs ?? [];

                                    if (classes.isEmpty) {
                                      return const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Text(
                                          "Nenhuma turma ativa nesta academia.",
                                        ),
                                      );
                                    }

                                    return Column(
                                      children: classes.map((classDoc) {
                                        final classData =
                                            classDoc.data()
                                                as Map<String, dynamic>;
                                        final professor =
                                            classData['professor'] ?? {};

                                        return ListTile(
                                          title: Text(
                                            classData['unitName'] ?? 'Turma',
                                          ),
                                          subtitle: Text(
                                            "Prof: ${professor['professorNickname'] ?? 'Instrutor'}",
                                          ),
                                          trailing: ElevatedButton(
                                            onPressed: () {
                                              formController.setLocationController(classDoc.id);
                                              formController.setClassNameController(classData['unitName']);
                                              formController.setProfessorIdController(professor['professorId']);
                                            },
                                            child: Text(
                                              

                                              formController.locationIdController.text.isNotEmpty ? 
                                              "Turma Selecionada" : "Selecionar Turma",
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
        ),

        // CustomTextInput(
        //   label: "Professor",
        //   prefixIcon: Icon(Icons.group_outlined),
        //   hintText: "Selecione o seu professor",
        //   locationController: formController.professorController,
        // ),
      ],
    );
  }


}
