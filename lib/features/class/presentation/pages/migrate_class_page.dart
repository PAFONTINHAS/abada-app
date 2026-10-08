import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_abada_capoeira/core/utils/message_handler.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/models/auth_status.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/custom_text_input.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/shared/class_location_list_widget/classes_location_list_widget.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/student_page_button_widget.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/class_migration_controller.dart';
import 'package:sistema_abada_capoeira/features/location/presentation/controllers/student_class_selection_controller.dart';

class MigrateClassPage extends StatefulWidget {
  const MigrateClassPage({super.key, required this.currentClass});

  final ClassEntity currentClass;

  @override
  State<MigrateClassPage> createState() => _MigrateClassPageState();
}

class _MigrateClassPageState extends State<MigrateClassPage> {
  @override
  void initState() {
    super.initState();

    final locationController = context.read<StudentClassSelectionController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      locationController.initNearbyLocations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileController = context.read<ProfileController>();
    final locationController = context.read<StudentClassSelectionController>();
    final classMigrationController = context.read<ClassMigrationController>();
    final authController = context.read<AuthController>();

    final user = profileController.userProfile;
    final lecturedClasses = user.lecturedClasses;

    return Scaffold(
      backgroundColor: const Color(0xFFAFAFA), // Fundo levemente acinzentado/limpo estilo abadá
      appBar: AppBar(
        title: const Text(
          "Troca de Turma / Graduação",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: ColorConstants.indigoColor, // Ou azul característico da escola
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StandardScaffoldBodyWidget(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- BANNER DE ALERTA DE MUDANÇA DE CORDA/TURMA ---
              Container(
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade400, width: 1),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: Colors.amber.shade900, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Solicite aqui a transferência para a sua nova turma no sistema ABADÁ.",
                        style: TextStyle(
                          color: Colors.amber.shade900,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // --- SEÇÃO SELEÇÃO DE TURMA ---
              Row(
                children: [
                  Icon(Icons.groups_rounded, color: ColorConstants.indigoColor),
                  const SizedBox(width: 8),
                  const Text(
                    "Selecione a Nova Turma",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(8.0),
                child: ClassesLocationListWidget(
                  currentClassEntityId: widget.currentClass.classId,
                  lecturedClasses: lecturedClasses,
                ),
              ),

              const SizedBox(height: 24),

              // --- SEÇÃO MOTIVO DA MIGRAÇÃO ---
              Row(
                children: [
                  Icon(Icons.edit_note_rounded, color: ColorConstants.indigoColor),
                  const SizedBox(width: 8),
                  const Text(
                    "Motivo da Transferência",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              CustomTextInput(
                label: "Motivo (Opcional)",
                hintText: "Ex: Mudança de horário, nova graduação, troca de academia...",
                controller: classMigrationController.migrationReason,
                maxLines: 4,
              ),

              const SizedBox(height: 32),

              // --- BOTAO DE AÇÃO ---
              StudentPageButtonWidget(
                icon: Icons.swap_horiz_rounded,
                buttonTitle: "Confirmar Solicitação",
                boxColor: ColorConstants.indigoColor,
                buttonColor: Colors.white,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: Row(
                          children: const [
                            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Atenção!",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Ao solicitar a transferência para outra turma, você será desvinculado da sua turma atual.",
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Você perderá o acesso às funcionalidades principais até que o professor da nova turma aprove sua solicitação.",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Nota: Se for um instrutor/professor, também perderá o acesso às turmas ministradas até a aprovação.",
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        actions: [
                          TextButton(
                            onPressed: () => context.pop(),
                            child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConstants.indigoColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              if (locationController.classRequestEntryEntity == null) {
                                context.pop();
                                return MessageHandler.showWarning(context, "Selecione uma turma primeiro");
                              }

                              final success = await classMigrationController.createMigrationRequest(
                                locationController.classRequestEntryEntity!,
                                user,
                                widget.currentClass.classId,
                              );

                              if (!context.mounted) return;

                              context.pop();

                              if (!success && classMigrationController.errorMessage != null) {
                                return MessageHandler.showError(
                                  context,
                                  "Erro ao criar solicitação: ${classMigrationController.errorMessage}",
                                );
                              }

                              MessageHandler.showSuccess(context, "Solicitação concluída. Redirecionando...");

                              authController.setAuthStatus(AuthStatus.initializing);
                            },
                            child: const Text("Continuar", style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}