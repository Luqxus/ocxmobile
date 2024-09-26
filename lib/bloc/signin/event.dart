import 'package:equatable/equatable.dart';

class SignInEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignInButtonPressed extends SignInEvent {
  final String email;

  SignInButtonPressed(this.email);

  @override
  List<Object?> get props => [email];
}
