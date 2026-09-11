import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClassRoutes {

  ClassRoutes._();

  static final route = GoRoute(
    path: '/classes',
    builder: (context, state){

      return Scaffold(
        appBar: AppBar(
          title: Text("Página de turmas"),
        ),
      );
    }
  );

}