import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/acess_profile.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';

class BottomNavigationPage extends StatelessWidget {
  const BottomNavigationPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;
  
  @override
  Widget build(BuildContext context) {
    final authController = context.read<AuthController>();
    final userRole = authController.userRole;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        // Aplica a cor do seu projeto no indicador da aba ativa
        indicatorColor: ColorConstants.indigoColor.withOpacity(0.2), 
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index, 
            initialLocation: index == navigationShell.currentIndex
          );
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: ColorConstants.indigoColor),
            label: "Início",
          ),
          NavigationDestination(
            icon: const Icon(Icons.group_outlined),
            selectedIcon: Icon(Icons.group, color: ColorConstants.indigoColor),
            label: "Turmas",
          ),
          NavigationDestination(
            icon: const Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event, color: ColorConstants.indigoColor),
            label: "Eventos",
          ),

          NavigationDestination(
            icon: const Icon(Icons.newspaper_outlined),
            selectedIcon: Icon(Icons.newspaper, color: ColorConstants.indigoColor),
            label: "Notícias",
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: ColorConstants.indigoColor),
            label: "Perfil",
          ),
        ],
      ),
    );
  }
}