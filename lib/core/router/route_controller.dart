import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';

class RouteController {

  RouteController._();

  static void redirectToDashboardPage({required BuildContext context}){

    context.go("/dashboard");
  }

  static void redirectToStudentClassPage({required BuildContext context, required ClassEntity classEntity}){

    context.go("/classes/class", extra: classEntity);
  }
}