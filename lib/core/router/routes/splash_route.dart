import 'package:go_router/go_router.dart';
import 'package:sistema_abada_capoeira/features/splash_screen/presentation/pages/splash_screen.dart';

class SplashRoute {

  SplashRoute._();

  static final route = GoRoute(
    path: '/splash',
    builder: (context, state) => SplashScreen()
  );
}