import 'package:equatable/equatable.dart';

class TransferState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TransferInitial extends TransferState {}

class DiscoverNfcLoading extends TransferState {}

class TransferError extends TransferState {
  final String message;

  TransferError(this.message);

  @override
  List<Object?> get props => [message];
}

class TransferSuccess extends TransferState {}

class TransactionPending extends TransferState {}
