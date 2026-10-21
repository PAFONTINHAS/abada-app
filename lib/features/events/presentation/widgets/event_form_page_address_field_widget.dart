import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/services/location_service/place_suggestion.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/custom_text_input.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_controller.dart';
import 'package:sistema_abada_capoeira/features/location/presentation/controllers/create_location_controller.dart';

class EventFormPageAddressFieldWidget extends StatelessWidget {
  const EventFormPageAddressFieldWidget({
    super.key,
    required this.formController,
  });

  final EventFormController formController;

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateLocationController>(
      builder: (context, controller, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextInput(
              label: "Endereço",
              hintText: "Digite o endereço do evento...",
              controller: formController.eventLocation,
              prefixIcon: const Icon(Icons.location_on_outlined),
              maxLines: 2,
              onChanged: (value) {
                formController.setEventLocation(value);
                // Dispara a busca no Photon via API
                controller.onSearchChanged(value);
              },
            ),

            // Exibe o indicador de carregamento
            if (controller.isSearching)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: LinearProgressIndicator(),
              ),

            
            if(controller.suggestions.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.suggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = controller.suggestions[index];
                    return ListTile(
                      leading: const Icon(
                        Icons.place,
                        color: ColorConstants.indigoColor,
                      ),
                      title: Text(suggestion.fullAddress),
                      onTap: () {

                        // 1. Guarda a sugestão selecionada (contendo lat/lng) no controller
                        controller.selectSuggestion(suggestion);

                        formController.setEventLocation(
                          suggestion.fullAddress,
                        );
                      },
                    );
                  },
                ),
              )
          ],
        );
      },
    );
  }
}
