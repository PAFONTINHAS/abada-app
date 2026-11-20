import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/error_graduation_history_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/graduation_timeline_tile_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/graduation_history_controller.dart';

class GraduationHistoryPage extends StatefulWidget {
  const GraduationHistoryPage({super.key});

  @override
  State<GraduationHistoryPage> createState() => _GraduationHistoryPageState();
}

class _GraduationHistoryPageState extends State<GraduationHistoryPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileController = context.read<ProfileController>();
      final historyController = context.read<GraduationHistoryController>();
      final userId = profileController.userProfile.uid;

      if (historyController.graduationHistory.isEmpty || historyController.errorMessage != null) {
        historyController.getHistory(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileController = context.read<ProfileController>();
    final userId = profileController.userProfile.uid;

    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorConstants.surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: ColorConstants.textPrimary),
        title: const Text(
          'Histórico de Graduação',
          style: TextStyle(
            color: ColorConstants.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Consumer<GraduationHistoryController>(
          builder: (context, controller, child) {
            // Estado de Carregamento
            if (controller.isLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: ColorConstants.indigoColor,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Carregando histórico de graduações...",
                      style: TextStyle(
                        color: ColorConstants.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }

            // Estado de Erro
            if (controller.errorMessage != null){   
              return ErrorGraduationHistoryWidget(
                errorMessage: controller.errorMessage!,
                onTryAgain: () => controller.getHistory(userId),
              );
            }
            // Estado Vazio
            if (controller.graduationHistory.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.military_tech_outlined,
                      size: 64,
                      color: ColorConstants.textSecondary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Nenhum histórico registrado.",
                      style: TextStyle(
                        color: ColorConstants.textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }

            // Lista de Histórico (Timeline)
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: controller.graduationHistory.length,
              itemBuilder: (context, index) {
                final item = controller.graduationHistory[index];
                final isLast = index == controller.graduationHistory.length - 1;

                return GraduationTimelineTile(
                  historyItem: item,
                  isLast: isLast,
                );
              },
            );
          },
        ),
      ),
    );
  }
}


