import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_mobile/bloc/wallet/event.dart';
import 'package:ocx_mobile/bloc/wallet/state.dart';
import 'package:ocx_mobile/models/wallet.dart';
import 'package:ocx_mobile/repository/wallet_repository.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletRepository walletRepository;
  WalletBloc(this.walletRepository) : super(WalletInitial()) {
    on<Fetch>(_fetchWallet);
    on<Decrement>(_decrementWallet);
    on<Increment>(_incrementWallet);
  }

  _fetchWallet(Fetch event, Emitter emit) async {
    // fetch wallet from wallet repository
    emit(WalletLoading());

    Wallet wallet = await walletRepository.getWallet();

    print(wallet.balance);

    emit(FetchedWallet(wallet));
  }

  _decrementWallet(Decrement event, Emitter emit) async {
    // pay or withdraw
  }
  _incrementWallet(Increment event, Emitter emit) async {
    // receive or deposit
  }
}
