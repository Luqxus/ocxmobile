import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:ocx_mobile/bloc/transfer/event.dart';
import 'package:ocx_mobile/bloc/transfer/state.dart';
import 'package:ocx_mobile/repository/wallet_repository.dart';

class TransferBloc extends Bloc<TransferEvent, TransferState> {
  WalletRepository walletRepository;

  TransferBloc(this.walletRepository) : super(TransferInitial()) {
    /// on triggered event is [TransferOfflineNFC]
    on<TransferOfflineNFC>(_transferOfflineNfc);

    /// on triggered event is [ReceiveNFC]
    on<ReceiveNFC>(_receive);

    /// on triggered event is [DiscoverNFCTag]
    on<DiscoverNFCTag>(_dicoverNfcTag);
  }

  _dicoverNfcTag(DiscoverNFCTag event, Emitter emit) async {
    emit(DiscoverNfcLoading());

    // check if nfc is supported
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable) {
      /// if not is support emit [TransferError]
      emit(TransferError("nfc not supported on this device"));
      return;
    }
    // Start Session
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        // prepare message from signed transaction
        emit(TransferOfflineNFC(amount: event.amount, tag: tag));
      },
    );
  }

  _receive(ReceiveNFC event, Emitter emit) async {
    // check if nfc is supported
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable) {
      /// if not is support emit [TransferError]
      emit(TransferError("nfc not supported on this device"));
      return;
    }

    // get wallet address from repository
    String? address = await walletRepository.getAddress();

    // Start Session
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        //on tag discovered

        /// emit [TransactionPending] state
        emit(TransactionPending());

        // new ndef from tag
        Ndef? ndef = Ndef.from(tag);

        // create message to transmit from receiver address
        NdefMessage message = NdefMessage([NdefRecord.createText(address)]);

        // write receiver address | message
        await ndef!.write(message);

        // read received tx message
        NdefMessage receivedMessage = await ndef.read();

        // parse message to string
        String tx = receivedMessage.records.first.payload.toString();

        // rollup transaction to blockchain
        await walletRepository.sendTransaction(tx: tx);
      },
    );
  }

  _transferOfflineNfc(TransferOfflineNFC event, Emitter emit) async {
    /// emit [TransactionPending]
    emit(TransactionPending());

    // create new ndef from tag
    Ndef? ndef = Ndef.from(event.tag);

    // read receiver's address
    NdefMessage receivedMessage = await ndef!.read();

    // parse receiver's address to string
    String address = receivedMessage.records.first.payload.toString();

    // sign transaction
    String tx = await walletRepository.signTransaction(
      value: event.amount,
      to: address,
    );

    // prepare message from signed transaction
    NdefMessage message = NdefMessage([NdefRecord.createText(tx)]);

    // write signed transaction to receiver
    await ndef.write(message);

    // Stop Session
    NfcManager.instance.stopSession();

    /// on success emit [TransferSuccess]
    emit(TransferSuccess());
  }
}
