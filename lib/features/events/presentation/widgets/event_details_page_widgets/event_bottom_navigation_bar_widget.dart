import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_details_page_widgets/canceled_event_bottom_navigation_bar_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_details_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_details_page_widgets/event_details_professor_bottom_options_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_details_page_widgets/event_details_revision_bottom_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_details_page_widgets/event_details_subscription_bottom_widget.dart';

class EventBottomNavigationBarWidget extends StatelessWidget {

  const EventBottomNavigationBarWidget({
    super.key,
    this.requestId,
    required this.controller,
    required this.eventEntity,
    required this.analyseEventDetails,
    required this.isSubscriptionAllowed,
    required this.isProfessorActionsAllowed,
  });

  final bool analyseEventDetails;
  final EventEntity? eventEntity;
  final bool isSubscriptionAllowed;
  final EventDetailsController controller;
  final bool isProfessorActionsAllowed;
  final String? requestId;
  @override
  Widget build(BuildContext context) {

    if(eventEntity == null) return SizedBox.shrink();

    final profileController = context.read<ProfileController>();

    final userId = profileController.userProfile.uid;

    final bool canManageSubscriptions = eventEntity!.eventCreatorId == userId && isProfessorActionsAllowed;
    final bool isValidEvent = !controller.isLoading;
    
    if(!isValidEvent) return SizedBox.shrink();

    final bool isRevisionAllowed =
        analyseEventDetails &&
        !isSubscriptionAllowed &&
        requestId != null &&
        controller.canDecide(requestId!, eventEntity!.eventId);


    if(isSubscriptionAllowed && !analyseEventDetails) return EventDetailsSubscriptionBottomButtonWidget(controller: controller);

    if(isRevisionAllowed) return EventDetailsRevisionBottomWidget(controller: controller, requestId: requestId!);

    if(!canManageSubscriptions) return UnavailableEventBottomNavigationBarWidget(controller: controller);

    if(canManageSubscriptions) return EventDetailsProfessorBottomOptionsWidget(controller: controller);
    
    return const SizedBox.shrink();
  }
}