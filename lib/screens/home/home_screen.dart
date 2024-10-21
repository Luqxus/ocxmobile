import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_mobile/bloc/wallet/bloc.dart';
import 'package:ocx_mobile/bloc/wallet/state.dart';
import 'package:ocx_mobile/screens/common/colors.dart';
import 'package:ocx_mobile/screens/home/widgets/wallet_action_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("John Doe"),
        actions: const [
          CircleAvatar(
            child: Icon(Icons.person_rounded),
          ),
          SizedBox(
            width: 20.0,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _balanceWidget(),
            const SizedBox(
              height: 32.0,
            ),
            // wallet action buttons
            // const WalletActionButtons(),
          ],
        ),
      ),
    );
  }

  _balanceWidget() {
    TextEditingController controller = TextEditingController(text: "00.00");
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        if (state is FetchedWallet) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                  children: [
                    TextSpan(
                        text: "R ",
                        style: TextStyle(color: textSecondary, fontSize: 22.0)),
                    TextSpan(
                      text: state.wallet.balance.toString(),
                      style: const TextStyle(fontSize: 32.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.visibility_rounded,
                  color: textSecondary,
                ),
              ),
            ],
          );
        }

        return CircularProgressIndicator();
      },
    );
  }
}
