import 'package:go_router/go_router.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/pages/profile_page.dart';

class ProfileRoutes {

  ProfileRoutes._();

  static final route = GoRoute(

    path: '/profile',
    builder: (context, state){
      return ProfilePage();
    }
  );
}