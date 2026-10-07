import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/acess_profile.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/pages/student_class_page.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/pages/professor_classes_page.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/pages/create_or_edit_class_page.dart';
import 'package:sistema_abada_capoeira/features/member_validation/presentation/pages/membership_requests_page.dart';

class ClassRoutes {
  ClassRoutes._();

  static final route = GoRoute(
    path: '/classes',
    builder: (context, state) {
      final userRole = context.watch<AuthController>().userRole;

      // return ProfessorClassesPage();

      switch (userRole) {
        case UserRole.student:
          return const StudentClassPage();
        default:
          return const ProfessorClassesPage();
      }
    },

    routes: [
      GoRoute(
        path: 'class',
        builder: (context, state) {
          final classEntity = state.extra as ClassEntity;

          return StudentClassPage(selectedClass: classEntity);
        },
      ),

      GoRoute(
        path: 'entry_requests',
        builder: (context, state){

          return const MembershipRequestsPage();
        }
      ),

      GoRoute(
        path: 'create',
        builder: (context, state) {
          return const CreateOrEditClassPage();
        },
      ),

      GoRoute(
        path: 'edit',
        builder: (context, state){

          final classEntity = state.extra as ClassEntity?;

          return CreateOrEditClassPage(classEntity: classEntity); 
        }
      )
    ],
  );
}
