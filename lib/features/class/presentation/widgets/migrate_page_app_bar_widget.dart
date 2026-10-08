import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';

class MigratePageAppBarWidget extends StatelessWidget implements PreferredSizeWidget{
  const MigratePageAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        "Troca de Turma / Graduação",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      centerTitle: true,
      backgroundColor:
          ColorConstants.indigoColor, // Ou azul característico da escola
      elevation: 2,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }


  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
