import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_abada_capoeira/core/router/route_controller.dart';
import 'package:sistema_abada_capoeira/core/utils/message_handler.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/shared/buttons/custom_text_button.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/custom_text_input.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/class_controller.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/header_unit_name_widget.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/schedule_controller.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/create_form_controller.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/create_or_edit_schedule_widget.dart';

class CreateOrEditClassPage extends StatefulWidget {
  const CreateOrEditClassPage({super.key, this.classEntity});

  final ClassEntity? classEntity;

  @override
  State<CreateOrEditClassPage> createState() => _CreateOrEditClassPageState();
}

class _CreateOrEditClassPageState extends State<CreateOrEditClassPage> {

  @override
  void initState(){

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_){

      final formController = context.read<ClassFormController>();
      final scheduleController = context.read<ScheduleController>();

      formController.clearControllers();
      scheduleController.clearFields();

      if(widget.classEntity == null) return;

      formController.beginEditing(widget.classEntity!);
      scheduleController.beginEditing(widget.classEntity!.schedule);
    });
  }

  @override
  Widget build(BuildContext context) {

    final classController = context.read<ClassController>();
    final profileController = context.read<ProfileController>();
    final scheduleController = context.read<ScheduleController>();
    final formController = context.watch<ClassFormController>(); 
    final user = profileController.userProfile;

    final bool isEditing = formController.isEditing;

    final pageTitle = isEditing ? "Criar Turma" : "Editar Turma";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          pageTitle,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: StandardScaffoldBodyWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            const HeaderUnitNameWidget(),

            SizedBox(height: 20),
          
            CustomTextInput(
              label: "Nome da Turma / Unidade",
              controller: formController.classUnitController,
              hintText: "Turma Santo Amaro / Unidade Batel",
              onChanged: (value) => formController.setClassUnitController(value),
            ),

            SizedBox(height: 20),

            CustomTextInput(
              label: "Endereço",
              hintText: "Rua das Lindoflorestas, 879",
              controller: formController.locationController,
              prefixIcon: Icon(Icons.location_on_outlined),
              onChanged: (value) => formController.setLocationController(value),
            ),

            SizedBox(height: 20),

            const CreateOrEditScheduleWidget(),

            SizedBox(height: 30,),

            CustomTextButton(
              text: pageTitle,
              onPressed: () async{

                final scheduleList = scheduleController.scheduleList;

                if (scheduleList.isEmpty){
                  return MessageHandler.showWarning(
                    context,
                    "Adicione ao menos um dia de aula com seu respectivo horário",
                  );
                }

                final classEntity = !isEditing
                    ? formController.buildClassEntity(scheduleList, user)
                    : formController.buildUpdatedClassEntity(scheduleList);

                if(classEntity == null) return;
                
                final success = !isEditing
                    ? await classController.createClassUsecase(classEntity)
                    : await classController.updateClassUsecase(classEntity);

                if(!context.mounted) return;

                if(success){

                  final successMessage = !isEditing
                      ? "Turma criada com sucesso!"
                      : "Turma atualizada com sucesso!";

                  MessageHandler.showSuccess(context, successMessage);

                  formController.clearControllers();
                  scheduleController.clearFields();
                  !isEditing ? context.pop() : RouteController.pushReplacementClassPage(context: context, classEntity: classEntity);

                  return;
                }

                MessageHandler.showError(context, "Erro: ${classController.errorMessage}");
              },
              color: ColorConstants.indigoColor,
              textColor: ColorConstants.whiteColor,
              alignment: Alignment.center
            )
          ]
        ),
      ),
    );
  }
}
