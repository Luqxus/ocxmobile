import 'package:equatable/equatable.dart';
import 'package:ocx_mobile/models/wallet.dart';

class WalletState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class FetchedWallet extends WalletState {
  final Wallet wallet;

  FetchedWallet(this.wallet);
}

class WalletError extends WalletState {
  final String message;

  WalletError(this.message);

  @override
  List<Object?> get props => [message];
}
