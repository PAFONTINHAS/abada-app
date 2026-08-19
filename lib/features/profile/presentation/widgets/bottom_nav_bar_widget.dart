import 'package:flutter/material.dart';

const Color _primaryPurple = Color(0xFF7C5CBF);

/// Bottom navigation 
/// (Início, Turmas, Eventos, Notícias, Perfil)


class BottomNavBarWidget extends StatelessWidget {
  final int currentIndex;

  const BottomNavBarWidget({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: _primaryPurple,
      unselectedItemColor: Colors.black45,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.groups_outlined),
          label: 'Turmas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          label: 'Eventos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article_outlined),
          label: 'Notícias',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Perfil',
        ),
      ],
    );
  }
}