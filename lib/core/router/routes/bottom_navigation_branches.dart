import 'package:go_router/go_router.dart';
import 'package:sistema_abada_capoeira/core/router/routes/class_routes.dart';
import 'package:sistema_abada_capoeira/core/router/routes/dashboard_routes.dart';
import 'package:sistema_abada_capoeira/core/router/routes/event_routes.dart';
import 'package:sistema_abada_capoeira/core/router/routes/profile_routes.dart';

class BottomNavigationBranches {

  BottomNavigationBranches ._();

  static final dashboardBranch = StatefulShellBranch(
    routes: [
      DashboardRoutes.route
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