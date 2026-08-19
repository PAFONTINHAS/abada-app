import 'dart:io';
import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';

class ExceptionHandler {

  ExceptionHandler._();

  static Either<Failure, T> handleException<T>({required Object exception, required String contextMessage}) {
    LoggingService.displayError("[ExceptionHandler.handleException] Erro: $exception. Contexto: $contextMessage.");

    // Tratar FirebaseAuthException ANTES do switch genérico
    if (exception is FirebaseAuthException) {
      switch (exception.code) {
        case 'email-already-in-use':
          return Left(EmailAlreadyInUseFailure("Este email já está registrado"));
        case 'requires-recent-login':
          return Left(ReauthenticateFailure("Por segurança, faça o login novamente antes de excluir a conta"));
        case 'user-not-found':
          return Left(NotFoundFailure("Usuário não encontrado"));
        case 'wrong-password':
          return Left(UnauthorizedFailure("Senha incorreta. Tente novamente ou faça login com google"));
        case 'invalid-email':
          return Left(ValidationFailure("Email inválido"));
        case 'user-disabled':
          return Left(UnauthorizedFailure("Esta conta foi desativada"));
        case 'invalid-credential':
          return Left(UnauthorizedFailure("Credenciais inválidas. Verifique seu email e senha"));
        case 'too-many-requests':
          return Left(UnauthorizedFailure("Bloqueamos seu dispositivo após muitas tentativas. Tente novamente mais tarde"));
        case 'no-current-user':
          return Left(UnauthorizedFailure("Nenhum usuário autenticado no momento"));
        default:
          return Left(ServerFailure('Erro de autenticação: ${exception.message}'));
      }
    }

    switch (exception.runtimeType) {
      case FirebaseException _:
        if( exception is FirebaseException){
          return Left(ServerFailure('Erro no Firestore: ${exception.message}'));
        }
        
        if( exception is FirebaseFunctionsException){
          return Left(ServerFailure('Erro da Cloud Function: ${exception.code} - ${exception.message}'));
        }

        return Left(ServerFailure('Erro desconhecido no servidor: ${exception.toString()}'));

      case SocketException _:
        return Left(NetworkFailure('Erro de conexão com a internet.'));

      case FormatException _:
        return Left(BadRequestFailure('Formato inválido: ${exception.toString()}'));

      case TimeoutException _:
        return Left(TimeoutFailure('Tempo de requisição excedido.'));

      case FileSystemException _:
        return Left(CacheFailure('Erro de cache ou arquivo: ${exception.toString()}'));


      default:
        return Left(UnknownFailure(
          'Ocorreu um erro inesperado ${exception.toString()}'
          '${" | Contexto: $contextMessage"}'
        ));
    }
  }

}


