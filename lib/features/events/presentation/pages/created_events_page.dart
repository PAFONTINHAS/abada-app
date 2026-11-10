
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/router/route_controller.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_policy.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/created_events_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/created_events_list_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/request_decision_details_dialog_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';

class CreatedEventsPage extends StatefulWidget {
  const CreatedEventsPage({super.key});

  @override
  State<CreatedEventsPage> createState() => _CreatedEventsPageState();
}

class _CreatedEventsPageState extends State<CreatedEventsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final profileController = context.read<ProfileController>();
      final controller = context.read<CreatedEventsController>();
      if (profileController.status != ProfileLoadStatus.loaded) return;
      await controller.getUserEvents(profileController.userProfile.uid);
    });
  }

  void _navigateToEventDetails({
    String? eventId,
    EventEntity? eventEntity,
  }) {
    RouteController.redirectToEventDetailsPage(
      context: context,
      eventId: eventId,
      eventEntity: eventEntity,
    );
  }

  void _showRequestDetailsModal(EventRequestEntity request) {
    showDialog(
      context: context,
      builder: (_) => RequestDecisionDetailsDialogWidget(
        request: request,
      ),
    );
  }

  Future<void> _navigateToEditEventRequest(
    EventRequestEntity request,
  ) async {
    final controller = context.read<CreatedEventsController>();

    if (!EventRequestPolicy.canEdit(request.status) ||
        controller.isOpeningEditor) {
      return;
    }

    controller.setOpeningEditor(true);

    try {
      final result = await controller.getEventById(request.eventId);

      if (!mounted) return;

      await result.fold<Future<void>>(
        (failure) async {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Não foi possível carregar o evento: ${failure.message}',
              ),
            ),
          );
        },
        (event) async {
          final saved =
              await RouteController.redirectToEditEventRequestPage(
                context: context,
                event: event,
                request: request,
              );

          if (!mounted || saved != true) return;

          await controller.getUserEvents(
            context.read<ProfileController>().userProfile.uid,
          );
        },
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao abrir a edição do evento: $error'),
        ),
      );
    } finally {
      controller.setOpeningEditor(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Meus Eventos",
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
        iconTheme: const IconThemeData(
          color: ColorConstants.textPrimary,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        child: CreatedEventsListWidget(
          onViewEventDetails: _navigateToEventDetails,
          onViewRequestDetails: _showRequestDetailsModal,
          onEditRequest: _navigateToEditEventRequest,
        ),
      ),
    );
  }
}
