import 'package:equatable/equatable.dart';
import 'package:nfc_manager/nfc_manager.dart';

class TransferEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReceiveNFC extends TransferEvent {}

class TransferOfflineNFC extends TransferEvent {
  final String amount;
  final NfcTag tag;

  TransferOfflineNFC({required this.amount, required this.tag});

  @override
  List<Object?> get props => [amount];
}

class DiscoverNFCTag extends TransferEvent {
  final String amount;

  DiscoverNFCTag({required this.amount});

  @override
  List<Object?> get props => [amount];
}

class TransferOnline extends TransferEvent {
  final String amount;
  final String address;

  TransferOnline({required this.address, required this.amount});

  @override
  List<Object?> get props => [amount, address];
}
