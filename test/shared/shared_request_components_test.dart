import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/member_validation/presentation/widgets/reject_request_dialog_widget.dart';
import 'package:sistema_abada_capoeira/features/member_validation/presentation/widgets/request_changes_dialog_widget.dart';
import 'package:sistema_abada_capoeira/shared/dialogs/controllers/request_justification_dialog_controller.dart';
import 'package:sistema_abada_capoeira/shared/dialogs/request_justification_dialog_widget.dart';
import 'package:sistema_abada_capoeira/shared/progress/phase_progress_marker_widget.dart';

void main() {
  test('submission controller only notifies on state changes', () {
    final controller = RequestJustificationDialogController();
    addTearDown(controller.dispose);
    var notifications = 0;
    controller.addListener(() => notifications++);
    expect(controller.isSubmitting, false);
    controller.setSubmitting(true);
    controller.setSubmitting(true);
    controller.setSubmitting(false);
    expect(controller.isSubmitting, false);
    expect(notifications, 2);
  });
  for (final reject in [true, false]) {
    testWidgets(
      'existing member decision reject=$reject retains validation, loading and true result',
      (tester) async {
        final pending = Completer<bool>();
        var calls = 0;
        bool? result;
        Future<bool> submit(String reason) {
          calls++;
          expect(reason, 'Motivo');
          return pending.future;
        }

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () async {
                    result = await showDialog<bool>(
                      context: context,
                      builder: (_) => reject
                          ? RejectRequestDialogWidget(onConfirm: submit)
                          : RequestChangesDialogWidget(onConfirm: submit),
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(FilledButton));
        await tester.pump();
        expect(find.text('Informe a justificativa.'), findsOneWidget);
        expect(calls, 0);
        await tester.enterText(find.byType(TextField), ' Motivo ');
        await tester.tap(find.byType(FilledButton));
        await tester.pump();
        expect(calls, 1);
        expect(
          tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
          isNull,
        );
        expect(
          tester.widget<IconButton>(find.byType(IconButton)).onPressed,
          isNull,
        );
        expect(
          tester
              .widget<TextButton>(find.widgetWithText(TextButton, 'Cancelar'))
              .onPressed,
          isNull,
        );
        expect(tester.widget<TextField>(find.byType(TextField)).enabled, false);
        pending.complete(true);
        await tester.pumpAndSettle();
        expect(result, true);
        expect(find.byType(RequestJustificationDialogWidget), findsNothing);
      },
    );
    testWidgets(
      'existing member decision reject=$reject cancel returns null without submitting',
      (tester) async {
        var calls = 0;
        Object? result = 'not closed';
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () async {
                    result = await showDialog<bool>(
                      context: context,
                      builder: (_) => reject
                          ? RejectRequestDialogWidget(
                              onConfirm: (_) async {
                                calls++;
                                return true;
                              },
                            )
                          : RequestChangesDialogWidget(
                              onConfirm: (_) async {
                                calls++;
                                return true;
                              },
                            ),
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Cancelar'));
        await tester.pumpAndSettle();
        expect(result, isNull);
        expect(calls, 0);
      },
    );
  }
  for (final completed in [true, false]) {
    testWidgets('generic marker accepts integer phases, completed=$completed', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 240,
              child: PhaseProgressMarkerWidget<int>(
                phase: 1,
                currentPhase: 1,
                phaseText: 'Step',
                phaseNumber: '1',
                phaseColor: Colors.black,
                isCompleted: completed,
              ),
            ),
          ),
        ),
      );
      final marker = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      expect(marker.duration, const Duration(milliseconds: 250));
      expect(
        (marker.decoration as BoxDecoration).color,
        ColorConstants.indigoColor,
      );
      expect(
        find.byIcon(Icons.check_rounded),
        completed ? findsOneWidget : findsNothing,
      );
      expect(find.text('1'), completed ? findsNothing : findsOneWidget);
      expect(
        tester.widget<Text>(find.text('Step')).style!.fontWeight,
        FontWeight.bold,
      );
    });
  }
  testWidgets(
    'generic marker accepts string phases and preserves inactive last-step styling',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PhaseProgressMarkerWidget<String>(
              phase: 'last',
              currentPhase: 'first',
              phaseText: 'Step',
              phaseNumber: '2',
              phaseColor: Colors.black,
              isCompleted: false,
              isLastPhase: true,
            ),
          ),
        ),
      );
      final marker = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      expect(
        (marker.decoration as BoxDecoration).color,
        ColorConstants.surfaceColor,
      );
      expect((marker.decoration as BoxDecoration).boxShadow, isEmpty);
      expect(find.byType(Expanded), findsNothing);
      expect(find.text('2'), findsOneWidget);
    },
  );
}
