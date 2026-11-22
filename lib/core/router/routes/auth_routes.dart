import 'package:go_router/go_router.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/pages/home_page.dart';

class AuthRoutes {
  AuthRoutes._();

  static final route = GoRoute(
    path: '/',
    builder: (context, state) {
      final tab = state.uri.queryParameters['tab'];
      final section = state.uri.queryParameters['section'];
      return HomePage(
        initialTab: tab == 'register' ? 1 : 0,
        publicSection: section == 'archive' ? 1 : 0,
      );
    },
  );
}
