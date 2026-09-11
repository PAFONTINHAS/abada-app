import 'package:go_router/go_router.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';
import 'package:sistema_abada_capoeira/core/router/routes/auth_routes.dart';
import 'package:sistema_abada_capoeira/core/router/routes/splash_route.dart';
import 'package:sistema_abada_capoeira/core/router/routes/bottom_navigation_branches.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/models/auth_status.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sistema_abada_capoeira/features/bottom_navigation/presentation/bottom_navigation_page.dart';

class AppRouter {

  AppRouter({required this.authController});
  
  final AuthController authController;

  late final GoRouter router = GoRouter(
    initialLocation: '/splash',
    refreshListenable: authController,
    redirect: (context, state){

      final String loginRoute = '/';
      final String splashRoute = '/splash';
      final String dashboardRoute = '/dashboard';

      final currentPath = state.uri.path;
      
      final AuthStatus authStatus = authController.status;

      if(authStatus == AuthStatus.unauthenticated){
        if(currentPath == loginRoute) return null;

        return loginRoute;
      }

      if(authStatus == AuthStatus.initializing || authStatus == AuthStatus.unknown){
        if(currentPath == splashRoute) return null;
        return splashRoute;
      }

      if(authStatus == AuthStatus.authenticated){
        if(currentPath == loginRoute || currentPath == splashRoute) return dashboardRoute;

        return null;
      }

      return null;
    },

    routes: [

      // StatefulShellRoute(branches: branches, navigatorContainerBuilder: navigatorContainerBuilder)
      AuthRoutes.route,
      SplashRoute.route,


      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell){
          return BottomNavigationPage(navigationShell: navigationShell);
        },

        branches: [
          BottomNavigationBranches.dashboardBranch,
          BottomNavigationBranches.classesBranch,
          BottomNavigationBranches.eventsBranch,
          BottomNavigationBranches.profileBranch
        ]
      )

    ]
  );


}