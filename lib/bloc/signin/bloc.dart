import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_mobile/bloc/auth/bloc.dart';
import 'package:ocx_mobile/bloc/auth/event.dart';
import 'package:ocx_mobile/bloc/signin/event.dart';
import 'package:ocx_mobile/bloc/signin/state.dart';
import 'package:ocx_mobile/repository/wallet_repository.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  WalletRepository repository;
  AuthenticationBloc authenticationBloc;

  SignInBloc({required this.authenticationBloc, required this.repository})
      : super(SignInInitial()) {
    on<SignInButtonPressed>(_signIn);
  }

  _signIn(SignInButtonPressed event, Emitter emit) async {
    try {
      emit(SignInLoading());
      String privKey = await repository.signIn(email: event.email);

      print(privKey);

      authenticationBloc.add(LoggedIn(event.email, privKey));
    } catch (e) {
      emit(SignInFailure(e.toString()));
    }
  }
}
