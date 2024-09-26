import 'package:equatable/equatable.dart';

class TxTypeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChangeTxType extends TxTypeEvent {
  final int index;

  ChangeTxType(this.index);

  @override
  List<Object?> get props => [index];
}
