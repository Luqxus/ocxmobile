import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_mobile/bloc/transfer/bloc.dart';
import 'package:ocx_mobile/bloc/transfer/state.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:pulsator/pulsator.dart';

class QRCodeAddress extends StatelessWidget {
  const QRCodeAddress({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder<QrImage>(
      future: _getImage(context),
      builder: (BuildContext context, AsyncSnapshot<QrImage> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return SizedBox(
            height: size.width * .7,
            width: size.width * .7,
            child: PrettyQrView(
              qrImage: snapshot.data!,
              decoration: const PrettyQrDecoration(),
            ),
          );
        } else {
          return const Text('Something went wrong!');
        }
      },
    );
  }

  Future<QrImage> _getImage(BuildContext ctx) async {
    String address =
        await BlocProvider.of<TransferBloc>(ctx).walletRepository.getAddress();
    final qrCode = QrCode(
      8,
      QrErrorCorrectLevel.H,
    )..addData(address);

    print(address);
    return QrImage(qrCode);
  }
}

class NFCScanner extends StatelessWidget {
  const NFCScanner({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<TransferBloc, TransferState>(builder: (context, state) {
      if (state is TransferSuccess) {
        return const Text("Success");
      } else if (state is TransferError) {
        return Text(state.message);
      } else if (state is TransactionPending) {
        return const CircularProgressIndicator();
      }

      return SizedBox(
        height: size.width * 0.8,
        width: size.width * 0.8,
        child: const Pulsator(
          style: PulseStyle(color: Colors.blue),
          count: 2,
          duration: Duration(seconds: 4),
          repeat: 0,
          startFromScratch: false,
          autoStart: true,
          fit: PulseFit.contain,
          child: Icon(
            Icons.nfc_rounded,
            color: Colors.white,
          ),
        ),
      );
    });
  }
}
