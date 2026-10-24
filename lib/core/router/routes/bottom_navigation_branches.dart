import 'package:go_router/go_router.dart';
import 'package:sistema_abada_capoeira/core/router/routes/classes_routes.dart';
import 'package:sistema_abada_capoeira/core/router/routes/dashboard_routes.dart';
import 'package:sistema_abada_capoeira/core/router/routes/event_routes.dart';
import 'package:sistema_abada_capoeira/core/router/routes/metrics_routes.dart';
import 'package:sistema_abada_capoeira/core/router/routes/news_routes.dart';
import 'package:sistema_abada_capoeira/core/router/routes/profile_routes.dart';

class BottomNavigationBranches {

  BottomNavigationBranches ._();

  static final dashboardBranch = StatefulShellBranch(
    routes: [
      DashboardRoutes.route
    ]
  );

  static final metricsBranch = StatefulShellBranch(
    routes: [

      MetricsRoutes.route
    ]
  );

  static final newsBranch = StatefulShellBranch(
    routes: [
      NewsRoutes.route
    ]
  );

  static final classesBranch = StatefulShellBranch(
    routes: [
      ClassRoutes.route
    ]
  );

  static final eventsBranch = StatefulShellBranch(
    routes: [

      EventRoutes.route

    ]
  );

  static final profileBranch = StatefulShellBranch(
    routes: [

      ProfileRoutes.route
    ]
  );



}