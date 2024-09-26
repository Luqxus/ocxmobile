import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_mobile/screens/transfer/bloc/event.dart';
import 'package:ocx_mobile/screens/transfer/bloc/state.dart';

class TxTypeBloc extends Bloc<TxTypeEvent, TxTypeState> {
  TxTypeBloc() : super(const TxTypeState(0)) {
    on<ChangeTxType>(_changeTxType);
  }

  _changeTxType(ChangeTxType event, Emitter emit) {
    emit(TxTypeState(event.index));
  }
}
