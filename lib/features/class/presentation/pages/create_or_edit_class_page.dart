import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/utils/message_handler.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/class_controller.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/schedule_controller.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/shared/buttons/custom_text_button.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/custom_text_input.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/header_unit_name_widget.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/create_or_edit_schedule_widget.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/create_or_edit_class_controller.dart';

class CreateOrEditClassPage extends StatefulWidget {
  const CreateOrEditClassPage({super.key, this.classEntity});

  final ClassEntity? classEntity;

  @override
  State<CreateOrEditClassPage> createState() => _CreateOrEditClassPageState();
}

class _CreateOrEditClassPageState extends State<CreateOrEditClassPage> {
  @override
  Widget build(BuildContext context) {


    final classController = context.read<ClassController>();
    final profileController = context.read<ProfileController>();
    final scheduleController = context.read<ScheduleController>();
    final createOrEditClassController = context.read<CreateOrEditClassController>(); 

    final user = profileController.userProfile;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Criar Turma",
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
              controller: createOrEditClassController.classUnitController,
              hintText: "Turma Santo Amaro / Unidade Batel",
              onChanged: (value) => createOrEditClassController.setClassUnitController(value),

            ),

            SizedBox(height: 20),

            CustomTextInput(
              label: "Endereço",
              hintText: "Rua das Lindoflorestas, 879",
              controller: createOrEditClassController.locationController,
              prefixIcon: Icon(Icons.location_on_outlined),
              onChanged: (value) => createOrEditClassController.setLocationController(value),
            ),

            SizedBox(height: 20),


            const CreateOrEditScheduleWidget(),

            SizedBox(height: 30,),
            CustomTextButton(
              text: "Criar Turma",
              onPressed: () async{

                final scheduleList = scheduleController.scheduleList;

                if (scheduleList.isEmpty){
                  return MessageHandler.showWarning(
                    context,
                    "Adicione ao menos um dia de aula com seu respectivo horário",
                  );
                }

                final classEntity = createOrEditClassController.buildClassEntity(context, scheduleList, user);

                
                final success = await classController.createClassUsecase(classEntity);

                if(!context.mounted) return;

                if(success){
                  MessageHandler.showSuccess(context, "Turma criada com sucesso!");

                  createOrEditClassController.clearControllers();
                  scheduleController.clearFields();
                  context.pop();

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
