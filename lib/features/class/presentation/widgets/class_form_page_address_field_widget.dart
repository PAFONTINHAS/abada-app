import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/custom_text_input.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/class_form_controller.dart';
import 'package:sistema_abada_capoeira/features/location/presentation/controllers/create_location_controller.dart';


class ClassFormPageAddressFieldWidget extends StatelessWidget {
  const ClassFormPageAddressFieldWidget({
    super.key,
    required this.createLocationController,
    required this.formController,
  });

  final CreateLocationController createLocationController;
  final ClassFormController formController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextInput(
          label: "Endereço",
          hintText: "Digite para buscar o endereço...",
          controller: formController.locationController,
          prefixIcon: const Icon(Icons.location_on_outlined),
          maxLines: 2,
          onChanged: (value) {
            formController.setLocationController(value);
            // Dispara a busca no Photon via API
            createLocationController.onSearchChanged(value);
          },
        ),

        // Exibe o indicador de carregamento
        if (createLocationController.isSearching)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: LinearProgressIndicator(),
          ),

        // Exibe a lista de sugestões retornadas pelo Photon
        if (createLocationController.suggestions.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: createLocationController.suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = createLocationController.suggestions[index];
                return ListTile(
                  leading: const Icon(
                    Icons.place,
                    color: ColorConstants.indigoColor,
                  ),
                  title: Text(suggestion.fullAddress),
                  onTap: () {
                    // 1. Guarda a sugestão selecionada (contendo lat/lng) no controller
                    createLocationController.selectSuggestion(suggestion);
                    // 2. Atualiza o texto do input
                    formController.locationController.text = suggestion.fullAddress;
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
