import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

class Exception extends Failure {
  const Exception({required String message}) : super(message: message);
}

class LocalDatabaseQueryFailure extends Failure {
  const LocalDatabaseQueryFailure({required String message})
      : super(message: message);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure({required String message}) : super(message: message);
}

class ParsingFailure extends Failure {
  const ParsingFailure({required String message}) : super(message: message);
}
