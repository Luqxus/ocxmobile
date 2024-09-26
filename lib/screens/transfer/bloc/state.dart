import 'package:equatable/equatable.dart';

class TxTypeState extends Equatable {
  final int index;

  const TxTypeState(this.index);

  TxTypeState copyWith(int index) {
    return TxTypeState(index);
  }

  @override
  List<Object?> get props => [index];
}
