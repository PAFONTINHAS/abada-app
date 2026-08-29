import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/models/request_type.dart';

class RequestTypeExtension {

  RequestTypeExtension._();

  static late Color _requestTypeColor;
  static Color get requestTypeColor => _requestTypeColor;

  static late Color _requestTypeBackgroundColor;
  static Color get requestTypeBackgroundColor => _requestTypeBackgroundColor;

  static late String _requestTypeText;
  static String get requestTypeText => _requestTypeText;

  static void checkRequestType(RequestType requestType){

    switch (requestType){
      case RequestType.event:
        _requestTypeColor = const Color.fromRGBO(31, 24, 171, 1);
        _requestTypeBackgroundColor = const Color.fromARGB(41, 31, 24, 171);
        _requestTypeText = 'Evento';
      break;

      case RequestType.cancellation:
       _requestTypeColor = const Color.fromRGBO(210, 31, 34, 1);
       _requestTypeBackgroundColor = const Color.fromARGB(41, 210, 31, 34);
       _requestTypeText = 'Cancelamento';
      break;
      
      case RequestType.dateChange:
        _requestTypeColor = const Color.fromRGBO(58, 34, 194, 1);
        _requestTypeBackgroundColor = const Color.fromARGB(41, 58, 34, 194);
        _requestTypeText = 'Alteração da data';
      break;
    }
  }

}