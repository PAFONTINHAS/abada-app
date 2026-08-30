import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EventRoutes {

  EventRoutes._();


  static final route = GoRoute(
    path: '/events',
    builder: (context, state){

      return Scaffold(
        appBar: AppBar(
          title: Text("Página de eventos"),
        ),
      );
    }
  );

}