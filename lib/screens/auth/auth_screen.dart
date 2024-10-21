import 'package:flutter/material.dart';
import 'package:ocx_mobile/screens/common/colors.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 64.0,
          horizontal: 20.0,
        ),
        child: Column(
          children: [
            // create wallet button
            _createWalletButton(),

            const SizedBox(
              height: 10.0,
            ),

            // import wallet button imports existing wallet
            _importWalletButton(),
          ],
        ),
      ),
    );
  }

  _createWalletButton() {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            onPressed: () {},
            child: Text("Create Wallet"),
          ),
        ),
      ],
    );
  }

  _importWalletButton() {
    Row(
      children: [
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(
                  color: primary,
                ),
              ),
            ),
            onPressed: () {},
            child: Text("Create Wallet"),
          ),
        ),
      ],
    );
  }
}
