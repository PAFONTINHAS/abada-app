import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_update_parameters.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/get_event_by_id_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/get_event_request_by_id_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/get_pending_events_requests_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/reject_event_request_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/request_event_changes_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_details_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_requests_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_details_navigation_bar_widget.dart';
import 'package:sistema_abada_capoeira/shared/dialogs/request_justification_dialog_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/acess_profile.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/user_profile_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'fixtures.dart';
import 'page_flow_test.dart' show ProfileStub;

class DecisionProfile extends ProfileStub {
  UserRole role = UserRole.coordinator;
  @override
  UserProfileEntity get userProfile =>
      super.userProfile.copyWith(uid: 'coordinator', role: role);
}

class DecisionUiRepository extends RepositoryStub {
  Completer<Either<Failure, void>>? pending;
  int decisions = 0;
  @override
  Future<Either<Failure, void>> rejectRequest(
    GenericRequestUpdateParameters params,
  ) async {
    decisions++;
    return pending == null ? result : await pending!.future;
  }

  @override
  Future<Either<Failure, void>> requestChanges(
    GenericRequestUpdateParameters params,
  ) => rejectRequest(params);
  @override
  Future<Either<Failure, List<EventRequestEntity>>>
  getPendingEventsRequests() async => Right([request]);
}

void main() {
  for (final reject in [true, false]) {
    for (final succeeds in [true, false]) {
      testWidgets(
        '${reject ? "reject" : "changes"} ${succeeds ? "success" : "failure"} feedback and busy buttons',
        (tester) async {
          final repository = DecisionUiRepository()..pending = Completer();
          final profile = DecisionProfile();
          final details = EventDetailsController(
            GetEventByIdUsecase(repository),
            GetEventRequestByIdUsecase(repository),
          );
          final requests = EventRequestsController(
            GetPendingEventsRequestsUsecase(repository),
            RejectEventRequestUsecase(repository),
            RequestEventChangesUsecase(repository),
          );
          addTearDown(profile.dispose);
          addTearDown(details.dispose);
          addTearDown(requests.dispose);
          await details.getEventById('event-1', requestId: 'request-1');
          await requests.getPendingRequests();
          await tester.pumpWidget(
            MultiProvider(
              providers: [
                ChangeNotifierProvider<ProfileController>.value(value: profile),
                ChangeNotifierProvider<EventRequestsController>.value(
                  value: requests,
                ),
              ],
              child: MaterialApp(
                home: Scaffold(
                  bottomNavigationBar: EventDetailsNavigationBarWidget(
                    controller: details,
                    requestId: 'request-1',
                  ),
                ),
              ),
            ),
          );
          await tester.tap(find.text(reject ? 'Recusar' : 'Ajustes'));
          await tester.pumpAndSettle();
          await tester.enterText(find.byType(TextField), 'Motivo');
          await tester.tap(find.text('Confirmar e Enviar'));
          await tester.pump();
          expect(requests.isProcessing, true);
          for (final button in tester.widgetList<OutlinedButton>(
            find.byType(OutlinedButton),
          )) {
            expect(button.onPressed, isNull);
          }
          expect(
            tester
                .widget<ElevatedButton>(
                  find.widgetWithText(ElevatedButton, 'Aprovar'),
                )
                .onPressed,
            isNull,
          );
          repository.pending!.complete(
            succeeds
                ? const Right(null)
                : const Left(NetworkFailure('offline')),
          );
          await tester.pumpAndSettle();
          expect(repository.decisions, 1);
          expect(requests.isProcessing, false);
          expect(
            find.text(
              succeeds
                  ? (reject
                        ? 'Solicitação recusada com sucesso.'
                        : 'Alterações solicitadas com sucesso.')
                  : 'offline',
            ),
            findsOneWidget,
          );
          expect(
            find.byType(RequestJustificationDialogWidget),
            succeeds ? findsNothing : findsOneWidget,
          );
        },
      );
    }
  }
  testWidgets('professor has no coordinator decision buttons', (tester) async {
    final repository = DecisionUiRepository();
    final profile = DecisionProfile()..role = UserRole.professor;
    final details = EventDetailsController(
      GetEventByIdUsecase(repository),
      GetEventRequestByIdUsecase(repository),
    );
    final requests = EventRequestsController(
      GetPendingEventsRequestsUsecase(repository),
      RejectEventRequestUsecase(repository),
      RequestEventChangesUsecase(repository),
    );
    addTearDown(profile.dispose);
    addTearDown(details.dispose);
    addTearDown(requests.dispose);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ProfileController>.value(value: profile),
          ChangeNotifierProvider<EventRequestsController>.value(
            value: requests,
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            bottomNavigationBar: EventDetailsNavigationBarWidget(
              controller: details,
              requestId: 'request-1',
            ),
          ),
        ),
      ),
    );
    expect(find.text('Recusar'), findsNothing);
    expect(find.text('Ajustes'), findsNothing);
    expect(find.text('Aprovar'), findsNothing);
    expect(repository.decisions, 0);
  });
}
