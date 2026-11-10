
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_type.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_phases_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/models/event_phases.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/services/event_form_actions.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_content.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_navigation_bar_widget.dart';

class EventFormPage extends StatefulWidget {
  const EventFormPage({
    super.key,
    this.eventToEdit,
    this.requestId,
    this.requestStatus,
    this.changeReason,
  });

  final EventEntity? eventToEdit;
  final String? requestId;
  final GenericRequestStatus? requestStatus;
  final String? changeReason;

  @override
  State<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      EventFormActions.initialize(
        context,
        event: widget.eventToEdit,
        requestId: widget.requestId,
        requestStatus: widget.requestStatus,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final form = context.watch<EventFormController>();
    final isEditing = widget.eventToEdit != null && widget.requestId != null;

    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Editar Evento' : 'Criar Evento',
          style: const TextStyle(
            color: ColorConstants.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: ColorConstants.surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        iconTheme: const IconThemeData(color: ColorConstants.textPrimary),
      ),
      body: form.isInitializing
          ? const Center(child: CircularProgressIndicator())
          : form.initializationError != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      form.initializationError!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                )
              : Selector<EventFormPhasesController, EventPhases>(
                  selector: (_, controller) => controller.currentPhase,
                  builder: (context, phase, child) {
                    final isRevision = phase == EventPhases.fourthPhase ||
                        (phase == EventPhases.thirdPhase &&
                            form.eventType == EventType.COMPETITION);
                    return Column(
                      children: [
                        EventFormContent(
                          phase: phase,
                          eventType: form.eventType,
                          requestStatus: widget.requestStatus,
                          changeReason: widget.changeReason,
                        ),
                        EventFormNavigationBarWidget(
                          proceedText: isRevision
                              ? (isEditing ? 'Salvar alterações' : 'Realizar Solicitação')
                              : 'Prosseguir',
                          showBackButton: phase != EventPhases.firstPhase,
                          onBack: () {
                            if (!form.isSubmitting) {
                              context.read<EventFormPhasesController>().previousFormPhase();
                            }
                          },
                          onProceed: () => EventFormActions.proceed(context, phase),
                          onFinish: () => EventFormActions.finish(
                            context, isEditing: isEditing),
                        ),
                      ],
                    );
                  },
                ),
    );
  }
}
