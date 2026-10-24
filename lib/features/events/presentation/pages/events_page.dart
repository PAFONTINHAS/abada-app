import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/utils/region_mapper.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/acess_profile.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/custom_text_input.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/events_controller.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/location/presentation/controllers/location_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/events_calendar_view_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/events_page_view_toggle_button_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/management_events_actions_section_widget.dart';
// import 'package:sistema_abada_capoeira/core/utils/region_mapper.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  String? _userCurrentState;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_){
      _fetchUserLocationAndSetRegion();
    });
  }

  Future<void> _fetchUserLocationAndSetRegion() async {

    final locationController = context.read<LocationController>();
    final eventsController = context.read<EventsController>();

    final locationEntity = locationController.userLocationEntity;

    if(locationEntity == null) return;

    // _userCurrentCity = locationEntity.city ?? "Cidade"; 
    _userCurrentState = locationEntity.state ?? "Estado"; 


    if (_userCurrentState != null) {
      final userRegion = RegionMapper.getRegionFromState(_userCurrentState!);

      eventsController.setSelectedRegion(userRegion);
      
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileController = context.read<ProfileController>();
    final userRole = profileController.userProfile.role;
    final eventsController = context.read<EventsController>();

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(!userRole.isStudent) const ManagementEventsActionsSectionWidget(),
            const SizedBox(height: 20),

            CustomTextInput(
              hintText: "Buscar por evento ou cidade...",
              prefixIcon: const Icon(Icons.search, color: ColorConstants.textSecondary),
              controller: eventsController.eventSearchController,
              onChanged: (value) => {eventsController.setEventSearchController(value)}, // Atualiza a lista filtrada
            ),

            const SizedBox(height: 16),

            SizedBox(
              height: 38,
              child: Selector<EventsController, String>(
                selector: (_, controller) => controller.selectedRegion,
                builder: (context, selectedRegion, child) {
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: RegionMapper.regions.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final region = RegionMapper.regions[index];
                      final isSelected = selectedRegion == region;

                      return FilterChip(
                        label: Text(region),
                        selected: isSelected,
                        onSelected: (selected) => eventsController.setSelectedRegion(region),
                        selectedColor: ColorConstants.indigoColor,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : ColorConstants.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
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
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            Selector<EventsController, int>(
              selector: (_, controller) => controller.selectedViewIndex,
              builder: (context, selectedViewIndex, child) {
                return Row(
                  children: [
                    Expanded(
                      child: EventsPageViewToggleButtonWidget(
                        title: "Calendário",
                        icon: Icons.calendar_month_outlined,
                        isSelected: eventsController.selectedViewIndex == 0,
                        onTap: () => eventsController.setSelectedViewIndex(0),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: EventsPageViewToggleButtonWidget(
                        title: "Mapa Interativo",
                        icon: Icons.map_outlined,
                        isSelected: eventsController.selectedViewIndex == 1,
                        onTap: () => eventsController.setSelectedViewIndex(1),
                      ),
                    ),
                  ],
                );
              },
            ),


            const SizedBox(height: 20),

            Selector<EventsController, int>(
              selector: (_, controller) => controller.selectedViewIndex,
              builder: (context, selectedViewIndex, child) {
                return Expanded(
                  child: selectedViewIndex == 0
                      ? EventsCalendarViewWidget()
                      : _buildInteractiveMapPlaceholder(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveMapPlaceholder() {
    return Container(
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
        ],
      ),
    );
  }
}