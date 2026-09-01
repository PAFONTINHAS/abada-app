import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteController {

  RouteController._();

  static void redirectToDashboardPage({required BuildContext context}){

    context.go("/dashboard");
  }

}