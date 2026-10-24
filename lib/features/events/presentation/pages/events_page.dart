import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/acess_profile.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/events_controller.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/management_events_actions_section_widget.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/custom_text_input.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  int _selectedViewIndex = 0; // 0 = Lista / Calendário, 1 = Mapa
  String _selectedRegion = 'Todas';
  
  final List<String> _regions = [
    'Todas',
    'Sul',
    'Sudeste',
    'Centro-Oeste',
    'Nordeste',
    'Norte',
  ];

  @override
  Widget build(BuildContext context) {

    final profileController = context.read<ProfileController>();
    final userRole = profileController.userProfile.role;

    final eventsController = context.read<EventsController>();

    final List<EventEntity> events = eventsController.events;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Eventos ABADÁ",
          style: TextStyle(
            color: ColorConstants.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: ColorConstants.surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 0.5,
      ),
      body: StandardScaffoldBodyWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Barra de Ações Rápidas (Criar, Meus Eventos e Solicitações)
            if(!userRole.isStudent) const ManagementEventsActionsSectionWidget(),

            const SizedBox(height: 20),

            // 2. Campo de Busca de Eventos (RF25)
            CustomTextInput(
              hintText: "Buscar por evento ou cidade...",
              prefixIcon: const Icon(Icons.search, color: ColorConstants.textSecondary),
              controller: eventsController.eventSearchController,
              onChanged: (value){
              },
            ),
            

            const SizedBox(height: 16),

            // 3. Filtros Por Região (RF24 / RF25)
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _regions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final region = _regions[index];
                  final isSelected = _selectedRegion == region;

                  return FilterChip(
                    label: Text(region),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedRegion = region;
                      });
                    },
                    selectedColor: ColorConstants.indigoColor,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : ColorConstants.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 13,
                    ),
                    backgroundColor: ColorConstants.surfaceColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? ColorConstants.indigoColor
                            : ColorConstants.borderColor,
                      ),
                    ),
                    showCheckmark: false,
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // 4. Alternador entre Lista/Calendário e Mapa Interativo (RF24 x RF25)
            Row(
              children: [
                Expanded(
                  child: _buildViewToggleButton(
                    title: "Calendário",
                    icon: Icons.calendar_month_outlined,
                    isSelected: _selectedViewIndex == 0,
                    onTap: () => setState(() => _selectedViewIndex = 0),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildViewToggleButton(
                    title: "Mapa Interativo",
                    icon: Icons.map_outlined,
                    isSelected: _selectedViewIndex == 1,
                    onTap: () => setState(() => _selectedViewIndex = 1),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 5. Área Principal de Exibição dos Eventos
            _selectedViewIndex == 0
                ? _buildEventsListPlaceholder()
                : _buildInteractiveMapPlaceholder(),
          ],
        ),
      ),
    );
  }


  Widget _buildViewToggleButton({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? ColorConstants.indigoColor : ColorConstants.surfaceColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? ColorConstants.indigoColor : ColorConstants.borderColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : ColorConstants.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : ColorConstants.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Placeholder para a Lista / Calendário (RF24)
  Widget _buildEventsListPlaceholder() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ColorConstants.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorConstants.borderColor),
      ),
      child: const Column(
        children: [
          Icon(Icons.event_note, size: 48, color: ColorConstants.textSecondary),
          SizedBox(height: 12),
          Text(
            "Lista de Eventos Próximos (RF24)",
            style: TextStyle(fontWeight: FontWeight.bold, color: ColorConstants.textPrimary),
          ),
          SizedBox(height: 4),
          Text(
            "Ordenados por geolocalização e data.",
            style: TextStyle(fontSize: 12, color: ColorConstants.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Placeholder para o Mapa Interativo (RF25)
  Widget _buildInteractiveMapPlaceholder() {
    return Container(
      height: 260,
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorConstants.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorConstants.borderColor),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map, size: 48, color: ColorConstants.textSecondary),
          SizedBox(height: 12),
          Text(
            "Mapa Interativo de Eventos (RF25)",
            style: TextStyle(fontWeight: FontWeight.bold, color: ColorConstants.textPrimary),
          ),
          SizedBox(height: 4),
          Text(
            "Visualização por estados e pins na região.",
            style: TextStyle(fontSize: 12, color: ColorConstants.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}