import 'package:equatable/equatable.dart';

// Classe que consolida todas as possíveis falhas do aplicativo (em desenvolvimento)
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message);
}

class ReauthenticateFailure extends Failure{
  const ReauthenticateFailure(super.message);
}


class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message);
}

class BadRequestFailure extends Failure {
  const BadRequestFailure(super.message);
}

// Falha específica para validação de dados de entrada
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

// Falha específica para email já registrado no Firebase Auth
class EmailAlreadyInUseFailure extends Failure {
  const EmailAlreadyInUseFailure(super.message);
}