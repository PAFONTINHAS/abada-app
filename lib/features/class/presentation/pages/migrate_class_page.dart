import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_abada_capoeira/core/utils/message_handler.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/models/auth_status.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/migrate_page_app_bar_widget.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/class_migration_controller.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/migrate_page_confirm_request_widget.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/migrate_page_change_class_banner_widget.dart';
import 'package:sistema_abada_capoeira/features/location/presentation/controllers/student_class_selection_controller.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/migrate_page_migrate_reason_section_widget.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/migrate_page_selection_class_section_title_widget.dart';

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
      appBar: const MigratePageAppBarWidget(),
      body: StandardScaffoldBodyWidget(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              const MigratePageChangeClassBannerWidget(),

              const SizedBox(height: 24),

              MigratePageClassSelectionSectionWidget(
                currentClassId: widget.currentClass.classId,
                lecturedClasses: lecturedClasses,
              ),


              const SizedBox(height: 24),

              const MigratePageMigrateReasonSectionWidget(),

              const SizedBox(height: 32),

              MigratePageConfirmRequestWidget(
                onConfirm: () async {
                  if (locationController.classRequestEntryEntity == null) {
                    context.pop();
                    return MessageHandler.showWarning(
                      context,
                      "Selecione uma turma primeiro",
                    );
                  }

                  final success = await classMigrationController
                      .createMigrationRequest(
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

                  MessageHandler.showSuccess(
                    context,
                    "Solicitação concluída. Redirecionando...",
                  );

                  authController.setAuthStatus(AuthStatus.initializing);
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
    );
  }
}