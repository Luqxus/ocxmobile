import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_mobile/app_wrapper.dart';
import 'package:ocx_mobile/bloc/auth/bloc.dart';
import 'package:ocx_mobile/bloc/auth/event.dart';
import 'package:ocx_mobile/bloc/wallet/bloc.dart';
import 'package:ocx_mobile/repository/default_wallet_repository.dart';
import 'package:ocx_mobile/service/secure_storage.dart';

void main() {
  runApp(OCXApp());
}

class OCXApp extends StatelessWidget {
  OCXApp({super.key});

  final WalletRepository _ethereumWalletRepository = DefaultWalletRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => WalletBloc(_ethereumWalletRepository),
          ),
          BlocProvider(
            create: (context) => AuthenticationBloc(
              secureStorage: SecureStorage(),
              walletRepository: _ethereumWalletRepository,
            )..add(AppStarted()),
          ),
        ],
        child: AppWrapper(),
      ),
    );
  }
}
