import 'package:logger/logger.dart';

// ignore_for_file: constant_identifier_names

enum LogEnvironment{
  PRODUCTION,
  DEVELOPMENT
}

class LoggingService{
  LoggingService ._();

  static final Logger _logger = Logger();

  static LogEnvironment _logEnvironment = LogEnvironment.DEVELOPMENT;

  static bool _isGenericLogEnabled = true;


  static void toggleGenericLogsStatus({required bool activate}){
    _isGenericLogEnabled = activate;
  }

  static void switchLogEnvironment(LogEnvironment environment){

    _logEnvironment = environment;
  }

  static void displayEntityId(String entityId){

    switch(_logEnvironment){
      case LogEnvironment.DEVELOPMENT: return _logger.i(entityId);
      case LogEnvironment.PRODUCTION: return print(entityId);  
    }
  }

  static void displayInfo(dynamic displayMessage, {bool bypassInfoLogBlock = false, bool blockLoggingInformation = false}){

    if(!_checkDisplayAvailability(bypassInfoLogBlock, blockLoggingInformation)) return;
    
    switch(_logEnvironment){
      case LogEnvironment.DEVELOPMENT: return _logger.i(displayMessage);
      case LogEnvironment.PRODUCTION: return print(displayMessage);  
    }
  }

  static void displayError(String displayMessage, {dynamic error, StackTrace? stack}){

    switch(_logEnvironment){
      case LogEnvironment.DEVELOPMENT: return _logger.e(displayMessage, error: error, stackTrace: stack);
      case LogEnvironment.PRODUCTION: return print("$displayMessage, erro: $error, stack: $stack");  
    }
  } 

  static void displayWarning(String displayMessage, {bool bypassInfoLogBlock = false, bool blockLoggingInformation = false}){

    if(!_checkDisplayAvailability(bypassInfoLogBlock, blockLoggingInformation)) return;

    switch(_logEnvironment){
      case LogEnvironment.DEVELOPMENT: return _logger.w(displayMessage);
      case LogEnvironment.PRODUCTION: return print(displayMessage);  
    }

  } 

  static bool _checkDisplayAvailability(bool bypassInfoLogBlock, bool blockLoggingInformation){

    if(blockLoggingInformation) return false;

    if(!_isGenericLogEnabled && !bypassInfoLogBlock) return false;

    return true;
  }

  static void checkGenericLogsStatus(){
    if(!_isGenericLogEnabled){
      _logger.w('''\n
        ||-------------------------|------------------------||
        ||                                                  ||
        ||  OS LOGS GENÉRICOS DO SISTEMA ESTÃO DESATIVADOS  ||
        ||                                                  ||
        ||-------------------------|------------------------||
      \n''');
    }
  }

  static void checkLogEnviroment(){
    if(_logEnvironment == LogEnvironment.PRODUCTION){

      _logger.w('''
        ||------------------------|---------------------------||
        ||                                                    ||
        ||  OS LOGS DO SISTEMA ESTÃO NO AMBIENTE DE PRODUÇÃO  ||
        ||                                                    ||
        ||------------------------|---------------------------||
      ''');
    }
  }
}