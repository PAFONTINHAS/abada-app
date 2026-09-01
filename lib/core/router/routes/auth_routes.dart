import 'package:go_router/go_router.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/pages/home_page.dart';

class AuthRoutes {

  AuthRoutes._();

  static final route = GoRoute(
    path: '/',
    builder: (context, state) => HomePage(),
  );

}