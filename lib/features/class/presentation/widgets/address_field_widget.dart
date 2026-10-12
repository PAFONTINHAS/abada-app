import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_abada_capoeira/core/utils/message_handler.dart';
import 'package:sistema_abada_capoeira/core/router/route_controller.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/shared/buttons/custom_text_button.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/custom_text_input.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/class_controller.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/header_unit_name_widget.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/schedule_controller.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/class_form_controller.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/create_or_edit_schedule_widget.dart';
import 'package:sistema_abada_capoeira/features/location/presentation/controllers/create_location_controller.dart';


class AddressFieldWidget extends StatelessWidget {
  const AddressFieldWidget({
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
