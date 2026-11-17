import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_update_parameters.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_decision_parameters.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_policy.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/reject_event_request_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/request_event_changes_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/get_event_by_id_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/get_event_request_by_id_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/resubmit_event_request_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_details_controller.dart';
import 'package:sistema_abada_capoeira/shared/dialogs/request_justification_dialog_widget.dart';
import 'fixtures.dart';

class DecisionRepository extends RepositoryStub {
  GenericRequestUpdateParameters? decision;
  @override
  Future<Either<Failure, void>> rejectRequest(
    GenericRequestUpdateParameters params,
  ) async {
    decision = params;
    return result;
  }

  @override
  Future<Either<Failure, void>> requestChanges(
    GenericRequestUpdateParameters params,
  ) => rejectRequest(params);
}

class DelayedRequestRepository extends RepositoryStub {
  final requests = <Completer<Either<Failure, EventRequestEntity>>>[];
  @override
  Future<Either<Failure, EventRequestEntity>> getEventRequestById(
    String requestId,
  ) {
    final pending = Completer<Either<Failure, EventRequestEntity>>();
    requests.add(pending);
    return pending.future;
  }
}

EventRequestDecisionParameters params({
  String request = 'request-1',
  String event = 'event-1',
  String actor = 'coordinator',
  String reason = '  Corrigir local  ',
}) => EventRequestDecisionParameters(
  requestId: request,
  eventId: event,
  coordinatorId: actor,
  coordinatorName: 'Coordenador',
  reason: reason,
);
void main() {
  for (final reject in [true, false]) {
    final label = reject ? 'reject' : 'changes';
    test('$label valid reason and metadata reach repository', () async {
      final repository = DecisionRepository();
      final result = reject
          ? await RejectEventRequestUsecase(repository)(params())
          : await RequestEventChangesUsecase(repository)(params());
      expect(result.isRight(), true);
      expect(repository.decision!.requestId, 'request-1');
      expect(repository.decision!.additionalData['eventId'], 'event-1');
      expect(repository.decision!.additionalData['decidedBy'], 'coordinator');
      expect(
        reject
            ? repository.decision!.rejectionReason
            : repository.decision!.changeReason,
        'Corrigir local',
      );
    });
    for (final invalid in [
      params(reason: '  '),
      params(request: ''),
      params(event: ' '),
      params(actor: ''),
    ]) {
      test(
        '$label rejects invalid parameters ${invalid.requestId}/${invalid.eventId}/${invalid.coordinatorId}/${invalid.reason}',
        () async {
          final repository = DecisionRepository();
          final result = reject
              ? await RejectEventRequestUsecase(repository)(invalid)
              : await RequestEventChangesUsecase(repository)(invalid);
          expect(
            result.fold((failure) => failure, (_) => null),
            isA<ValidationFailure>(),
          );
          expect(repository.decision, isNull);
        },
      );
    }
    test('$label repository failure remains visible', () async {
      final repository = DecisionRepository()
        ..result = const Left(NetworkFailure('offline'));
      final result = reject
          ? await RejectEventRequestUsecase(repository)(params())
          : await RequestEventChangesUsecase(repository)(params());
      expect(result, const Left<Failure, void>(NetworkFailure('offline')));
    });
  }
  for (final status in GenericRequestStatus.values) {
    test('policy and details decision status ${status.name}', () async {
      final repository = RepositoryStub()
        ..request = RepositoryStub().request.copyWith(status: status);
      final controller = EventDetailsController(
        GetEventByIdUsecase(repository),
        GetEventRequestByIdUsecase(repository),
      );
      addTearDown(controller.dispose);
      final allowed =
          status == GenericRequestStatus.requested ||
          status == GenericRequestStatus.updated;
      expect(EventRequestPolicy.canDecide(status), allowed);
      expect(
        await controller.getEventById('event-1', requestId: 'request-1'),
        allowed,
      );
      expect(controller.canDecide('request-1', 'event-1'), allowed);
      final editable =
          status == GenericRequestStatus.requested ||
          status == GenericRequestStatus.changesRequested;
      expect(EventRequestPolicy.canEdit(status), editable);
    });
  }
  test('details rejects mismatched requester', () async {
    final repository = RepositoryStub()
      ..request = RepositoryStub().request.copyWith(requesterId: 'other');
    final controller = EventDetailsController(
      GetEventByIdUsecase(repository),
      GetEventRequestByIdUsecase(repository),
    );
    addTearDown(controller.dispose);
    expect(
      await controller.getEventById('event-1', requestId: 'request-1'),
      false,
    );
    expect(controller.canDecide('request-1', 'event-1'), false);
  });
  for (final requestFails in [true, false]) {
    test(
      'details handles ${requestFails ? "request" : "event"} query failure',
      () async {
        final repository = RepositoryStub()
          ..failRequestRead = requestFails
          ..failRead = !requestFails;
        final controller = EventDetailsController(
          GetEventByIdUsecase(repository),
          GetEventRequestByIdUsecase(repository),
        );
        addTearDown(controller.dispose);
        expect(
          await controller.getEventById('event-1', requestId: 'request-1'),
          false,
        );
        expect(controller.errorMessage, contains('offline'));
        expect(controller.isLoading, false);
        expect(controller.eventEntity, isNull);
        expect(controller.canDecide('request-1', 'event-1'), false);
      },
    );
  }
  test(
    'new request validation rejects blank ID without querying repository',
    () async {
      expect(
        (await GetEventRequestByIdUsecase(RepositoryStub())(' ')).isLeft(),
        true,
      );
    },
  );
  test('old request failure cannot overwrite newer verified result', () async {
    final repository = DelayedRequestRepository();
    final controller = EventDetailsController(
      GetEventByIdUsecase(repository),
      GetEventRequestByIdUsecase(repository),
    );
    addTearDown(controller.dispose);
    final old = controller.getEventById('event-1', requestId: 'old');
    await Future<void>.delayed(Duration.zero);
    expect(controller.canDecide('old', 'event-1'), false);
    final current = controller.getEventById('event-1', requestId: 'request-1');
    await Future<void>.delayed(Duration.zero);
    repository.requests[1].complete(Right(repository.request));
    expect(await current, true);
    repository.requests[0].complete(
      const Left(NetworkFailure('stale offline')),
    );
    expect(await old, false);
    expect(controller.errorMessage, isNull);
    expect(controller.canDecide('request-1', 'event-1'), true);
  });
  for (final invalidEventId in [true, false]) {
    test(
      'resubmit validates ${invalidEventId ? "event" : "request"} ID before upload',
      () async {
        final repository = RepositoryStub();
        final result = await ResubmitEventRequestUsecase(repository)(
          invalidEventId ? 'request-1' : ' ',
          eventFixture().copyWith(eventId: invalidEventId ? '' : 'event-1'),
          null,
        );
        expect(result.isLeft(), true);
        expect(repository.uploads, 0);
        expect(repository.submitted, isNull);
      },
    );
  }
  for (final title in [
    'Recusar Solicita\u00e7\u00e3o',
    'Solicitar Altera\u00e7\u00f5es',
  ]) {
    testWidgets('$title requires reason and disables duplicate submission', (
      tester,
    ) async {
      var calls = 0;
      final pending = Completer<bool>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RequestJustificationDialogWidget(
              title: title,
              hintText: 'Motivo',
              confirmLabel: 'Confirmar e Enviar',
              icon: Icons.edit_outlined,
              actionColor: Colors.red,
              onConfirm: (reason) {
                calls++;
                expect(reason, 'Motivo v\u00e1lido');
                return pending.future;
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('Confirmar e Enviar'));
      await tester.pump();
      expect(find.text('Informe a justificativa.'), findsOneWidget);
      expect(calls, 0);
      await tester.enterText(find.byType(TextField), ' Motivo v\u00e1lido ');
      await tester.tap(find.text('Confirmar e Enviar'));
      await tester.pump();
      expect(calls, 1);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      expect(tester.widget<TextField>(find.byType(TextField)).enabled, false);
      pending.complete(false);
      await tester.pumpAndSettle();
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNotNull,
      );
    });
    testWidgets('$title shows unexpected submission error', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RequestJustificationDialogWidget(
              title: title,
              hintText: 'Motivo',
              confirmLabel: 'Confirmar e Enviar',
              icon: Icons.edit_outlined,
              actionColor: Colors.red,
              onConfirm: (_) async => throw StateError('test failure'),
            ),
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), 'Motivo');
      await tester.tap(find.text('Confirmar e Enviar'));
      await tester.pumpAndSettle();
      expect(
        find.text(
          'N\u00e3o foi poss\u00edvel concluir a a\u00e7\u00e3o. Tente novamente.',
        ),
        findsOneWidget,
      );
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNotNull,
      );
    });
  }
}
