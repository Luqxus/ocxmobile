import 'package:equatable/equatable.dart';

class AuthenticationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoggedIn extends AuthenticationEvent {
  final String email;
  final String privKey;

  LoggedIn(this.email, this.privKey);

  @override
  List<Object?> get props => [email, privKey];
}

class LoggedOut extends AuthenticationEvent {}

class AppStarted extends AuthenticationEvent {}

class CompleteOnboarding extends AuthenticationEvent {}
