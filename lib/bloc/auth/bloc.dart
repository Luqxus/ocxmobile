import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_mobile/bloc/auth/event.dart';
import 'package:ocx_mobile/bloc/auth/state.dart';
import 'package:ocx_mobile/models/money.dart';
import 'package:ocx_mobile/repository/wallet_repository.dart';
import 'package:ocx_mobile/service/secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final SecureStorage secureStorage;
  final WalletRepository walletRepository;
  AuthenticationBloc(
      {required this.secureStorage, required this.walletRepository})
      : super(AuthenticationInitial()) {
    on<LoggedIn>(_loggedIn);
    on<LoggedOut>(_loggedOut);
    on<AppStarted>(_appStarted);
    on<CompleteOnboarding>(_completeOnboarding);
  }

  _loggedIn(LoggedIn event, Emitter emit) async {
    emit(AuthenticationLoading());

    // persist user email and privKey in encrypted storage
    await secureStorage.persistEmailAndSecretKey(
        email: event.email, secretKey: event.privKey);

    //  get nonce from chain
    int nonce = await walletRepository.getNonce();

    // get current wallet balance
    Money money = await walletRepository.getBalance();
    // save balance for offline use
    await walletRepository.setBalance(money);

    // set nonce in encrypted storage
    secureStorage.setNonce(nonce);
    await _init(emit);
  }

  _loggedOut(LoggedOut event, Emitter emit) async {}

  _appStarted(AppStarted event, Emitter emit) async {
    await _checkIfFirstUseAfterInstall();

    if (await _checkIfOnboardingComplete()) {
      await _init(emit);
      return;
    }

    emit(OnboardingNotComplete());
  }

  _completeOnboarding(CompleteOnboarding event, Emitter emit) async {
    emit(AuthenticationLoading());
  }

  _init(Emitter emit) async {
    // check if privKey in encrypted storage
    if (await secureStorage.hasSecretKey()) {
      // if available, app is authenticated
      emit(AuthenticationAuthenticated());
      return;
    }

    // if not available, app unauthenticated
    emit(AuthenticationUnauthenticated());
  }

  _checkIfFirstUseAfterInstall() async {
    // get shared prefs instance
    final prefs = await SharedPreferences.getInstance();

    // check if first run after install
    // if first_run is null
    if (prefs.getBool('first_run') ?? true) {
      // if first use clean up encrypted storage
      secureStorage.deleteAll();

      // set first run to false
      prefs.setBool('first_run', false);
    }
  }

  _checkIfOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    bool isComplete = true;

    prefs.getBool('onboarding_complete') ?? false;

    return isComplete;
  }
}
