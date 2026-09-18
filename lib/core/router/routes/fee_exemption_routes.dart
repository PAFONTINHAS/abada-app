import 'package:go_router/go_router.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/presentation/pages/fee_exemption_complementation_page.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/presentation/pages/fee_exemption_details_page.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/presentation/pages/fee_exemption_request_page.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/presentation/pages/fee_exemption_sent_page.dart';

class FeeExemptionRoutes {
  FeeExemptionRoutes._();

  static final requestRoute = GoRoute(
    path: '/fee-exemption/request',
    builder: (context, state) {
      return const FeeExemptionRequestPage();
    },
  );

  static final sentRoute = GoRoute(
    path: '/fee-exemption/sent/:feeExemptionId',
    builder: (context, state) {
      final feeExemptionId =
          state.pathParameters['feeExemptionId']!;

      return FeeExemptionSentPage(
        feeExemptionId: feeExemptionId,
      );
    },
  );

  static final detailsRoute = GoRoute(
    path: '/fee-exemption/details/:feeExemptionId',
    builder: (context, state) {
      final feeExemptionId =
          state.pathParameters['feeExemptionId']!;

      return FeeExemptionDetailsPage(
        feeExemptionId: feeExemptionId,
      );
    },
  );

  static final complementationRoute = GoRoute(
    path:
        '/fee-exemption/complementation/:feeExemptionId',
    builder: (context, state) {
      final feeExemptionId =
          state.pathParameters['feeExemptionId']!;

      return FeeExemptionComplementationPage(
        feeExemptionId: feeExemptionId,
      );
    },
  );

  static final routes = [
    requestRoute,
    sentRoute,
    detailsRoute,
    complementationRoute,
  ];
}