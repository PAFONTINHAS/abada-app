import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/pages/professor_classes_page.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/pages/student_class_page.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/acess_profile.dart';

class ClassRoutes {

  ClassRoutes._();

  static final route = GoRoute(
    path: '/classes',
    builder: (context, state){

      final userRole = context.watch<AuthController>().userRole;

      return ProfessorClassesPage();

      // switch(userRole){
      //   case UserRole.student: return StudentClassPage();
      //   default: return ProfessorClassesPage();
      // }
    }
  );

}