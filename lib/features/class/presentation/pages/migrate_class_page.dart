import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/utils/message_handler.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/models/auth_status.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/class_migration_controller.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/acess_profile.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/custom_text_input.dart';
import 'package:sistema_abada_capoeira/shared/class_location_list_widget/classes_location_list_widget.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/student_page_button_widget.dart';
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
      appBar: AppBar(title: Text("Migração de Turmas")),
      body: StandardScaffoldBodyWidget(
        child: Column(
          children: [
            Text("Selecione uma turma"),

            ClassesLocationListWidget(
              currentClassEntityId: widget.currentClass.classId,
              lecturedClasses: lecturedClasses,
            ),

            Divider(),

            CustomTextInput(
              label: "Motivo da Transferência (opcional)",
              hintText: "Explique o motivo da sua solicitação",
              controller: classMigrationController.migrationReason,
              maxLines: 4,
            ),

            StudentPageButtonWidget(
              icon: Icons.cached_outlined,
              buttonTitle: "Enviar Solicitação",
              boxColor: ColorConstants.indigoColor,
              buttonColor: Colors.white,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Você tem certeza disso?"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Ao solicitar a transferencia para outra turma, você é desvinculado da turma atual e perde acesso às funcionalidades principais do aplicativo até ser aprovado pelo professor da nova turma",
                          ),
                          Text(
                            "Nota: se você for um professor, perderá o acesso às suas turmas até a inserção na nova turma",
                          ),
                        ],
                      ),
                      actions: [
                        ElevatedButton(onPressed: () => context.pop(), child: Text("Cancelar")),

                        ElevatedButton(onPressed: () async {

                          if(locationController.classRequestEntryEntity == null){
                            context.pop();
                            return MessageHandler.showWarning(context, "Selecione uma turma primeiro");
                          }

                          final success = await classMigrationController.createMigrationRequest(
                            locationController.classRequestEntryEntity!,
                            user,
                            widget.currentClass.classId,
                          );

                          if(!context.mounted) return;

                          if(!success && classMigrationController.errorMessage != null){

                            return MessageHandler.showError(context, "Erro ao criar solicitação: ${classMigrationController.errorMessage}");
                          }

                          MessageHandler.showSuccess(context, "Solicitação concluida. Redirecionando...");

                          authController.setAuthStatus(AuthStatus.initializing);

                        }, child: Text("Continuar")),

                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
