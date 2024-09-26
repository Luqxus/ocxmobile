import 'package:equatable/equatable.dart';
import 'package:ocx_mobile/models/money.dart';

class WalletEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class Fetch extends WalletEvent {}

class Decrement extends WalletEvent {
  final Money money;

  Decrement(this.money);

  @override
  List<Object?> get props => [money];
}

class Increment extends WalletEvent {
  final Money money;

  Increment(this.money);

  @override
  List<Object?> get props => [money];
}

class Deposit extends WalletEvent {}
