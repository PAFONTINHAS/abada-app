import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';

class EventRegistrantsAppbarWidget extends StatelessWidget implements PreferredSizeWidget{
  const EventRegistrantsAppbarWidget({super.key, required this.onExportButtonPressed});

  final VoidCallback onExportButtonPressed;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    
    return AppBar(
        title: const Text(
          "Lista de Inscritos",
          style: TextStyle(
            color: ColorConstants.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: ColorConstants.surfaceColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: ColorConstants.textPrimary),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
            tooltip: "Exportar para PDF",
            onPressed: onExportButtonPressed,
          ),
        ],
      );
  }
}