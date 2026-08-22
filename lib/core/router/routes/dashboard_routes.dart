import 'package:go_router/go_router.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/pages/coordenator_dashboard_page.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/pages/professor_dashboard_page.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/pages/student_dashboard_page.dart';

class DashboardRoutes {

  static final dashboardRoute = GoRoute(
    path: '/dashboard',
    routes: [
      _professorDashboardPage,
      _studentDashboardPage,
      _coordenatorDashboardPage,
    ]
  );

  static final _professorDashboardPage = GoRoute(
    path: 'professor',
    builder: (context, state) => ProfessorDashboardPage(),
  );

  static final _studentDashboardPage = GoRoute(
    path: 'student',
    builder: (context, state) => StudentDashboardPage(),
  );

  static final _coordenatorDashboardPage = GoRoute(
    path: 'coordenator',
    builder: (context, state) => CoordenatorDashboardPage(),
  );
}