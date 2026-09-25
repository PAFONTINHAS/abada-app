import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/app_spacing.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/header_unit_name_widget.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/custom_text_input.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/schedule_view_list_widget.dart';
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


    final controller = context.read<CreateOrEditClassController>();

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
              controller: controller.classUnitController,
              hintText: "Turma Santo Amaro / Unidade Batel",
              onChanged: (value) => controller.setClassUnitController(value),

            ),

            SizedBox(height: 20),

            CustomTextInput(
              label: "Endereço",
              hintText: "Rua das Lindoflorestas, 879",
              controller: controller.locationController,
              prefixIcon: Icon(Icons.location_on_outlined),
              onChanged: (value) => controller.setLocationController(value),
            ),

            SizedBox(height: 20),

            const ScheduleViewListWidget(),

            const CreateOrEditScheduleWidget(),

          ]
        ),
      ),
    );
  }
}
