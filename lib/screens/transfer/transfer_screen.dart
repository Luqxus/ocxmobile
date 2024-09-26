import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_mobile/bloc/transfer/bloc.dart';
import 'package:ocx_mobile/bloc/transfer/event.dart';
import 'package:ocx_mobile/screens/common/colors.dart';
import 'package:ocx_mobile/screens/transfer/bloc/bloc.dart';
import 'package:ocx_mobile/screens/transfer/bloc/event.dart';
import 'package:ocx_mobile/screens/transfer/bloc/state.dart';
import 'package:ocx_mobile/screens/transfer/widgets/transaction_type.dart';

class TransferScreen extends StatelessWidget {
  const TransferScreen({super.key});

  // final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 32.0,
            left: 20.0,
            right: 20.0,
          ),
          child: Column(
            children: [
              // backbutton
              _backButton(context),

              const SizedBox(
                height: 32.0,
              ),
              // transaction type selector
              _transactionTypeSelector(),

              const SizedBox(
                height: 64.0,
              ),
              // selected transaction type builder
              _transactionTypeBuilder(),
            ],
          ),
        ),
      ),
    );
  }

  _transactionTypeSelector() {
    return BlocBuilder<TxTypeBloc, TxTypeState>(builder: (context, state) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: (state.index == 0) ? primary : secondary,
            ),
            onPressed: () {
              BlocProvider.of<TxTypeBloc>(context).add(ChangeTxType(0));
            },
            child: const Text("QR"),
          ),
          const SizedBox(
            width: 8.0,
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: (state.index == 1) ? primary : secondary,
            ),
            onPressed: () {
              BlocProvider.of<TxTypeBloc>(context).add(ChangeTxType(1));
              BlocProvider.of<TransferBloc>(context)
                  .add(DiscoverNFCTag(amount: "1"));
            },
            child: const Text("NFC"),
          ),
        ],
      );
    });
  }

  _transactionTypeBuilder() {
    return BlocBuilder<TxTypeBloc, TxTypeState>(
      builder: (context, state) {
        if (state.index == 0) {
          return const QRCodeAddress();
        }
        return const NFCScanner();
      },
    );
  }

  _backButton(BuildContext ctx) {
    // back button
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(ctx);
          },
          icon: Icon(
            Icons.clear_rounded,
            color: textPrimary,
          ),
        ),
      ],
    );
  }
}
