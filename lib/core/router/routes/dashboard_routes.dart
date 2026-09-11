import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_role.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/pages/coordenator_dashboard_page.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/pages/professor_dashboard_page.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/pages/student_dashboard_page.dart';
import 'package:sistema_abada_capoeira/features/waiting_layer/presentation/pages/waiting_page.dart';

class DashboardRoutes {

  DashboardRoutes._();

  static final route = GoRoute(
    path: '/dashboard',
    builder: (context, state){

      final userRole = context.watch<AuthController>().userRole;

      switch(userRole){
        
        case UserRole.professor: return const ProfessorDashboardPage();
        case UserRole.student: return const StudentDashboardPage();
        case UserRole.unvalidatedUser: return const WaitingPage();
        case UserRole.unknown: return Placeholder();
        case UserRole.coordenator: return CoordenatorDashboardPage();
      }
    },
  );

}