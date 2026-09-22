import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/custom_text_input.dart';

class CreateOrEditClassPage extends StatelessWidget {
  const CreateOrEditClassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Turmas",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: StandardScaffoldBodyWidget(
        child: Column(
          children: [

            CustomTextInput(
              
            )


          ],
        ),
      ),
    );
  }
}