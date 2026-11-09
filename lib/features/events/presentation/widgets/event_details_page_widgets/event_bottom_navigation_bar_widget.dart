import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_details_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_details_page_widgets/event_details_professor_bottom_options_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_details_page_widgets/event_details_revision_bottom_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_details_page_widgets/event_details_subscription_bottom_widget.dart';

class EventBottomNavigationBarWidget extends StatelessWidget {

  const EventBottomNavigationBarWidget({
    super.key,
    required this.controller,
    required this.eventEntity,
    required this.analyseEventDetails,
    required this.isSubscriptionAllowed,
  });

  final bool analyseEventDetails;
  final EventEntity? eventEntity;
  final bool isSubscriptionAllowed;
  final EventDetailsController controller;
  @override
  Widget build(BuildContext context) {

    final profileController = context.read<ProfileController>();
    final userId = profileController.userProfile.uid;

    bool isValidEvent = eventEntity != null && !controller.isLoading;

    if(!isValidEvent) return SizedBox.shrink();

    bool isEventCreator = eventEntity!.eventCreatorId == userId;

    if(isEventCreator) return EventDetailsProfessorBottomOptionsWidget(controller: controller);

    if(isSubscriptionAllowed && !analyseEventDetails) return EventDetailsSubscriptionBottomButtonWidget(controller: controller);

    if(analyseEventDetails && !isSubscriptionAllowed) return EventDetailsRevisionBottomWidget(controller: controller);

    return const SizedBox.shrink();
  }
}