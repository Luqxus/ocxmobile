import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocx_mobile/bloc/auth/bloc.dart';
import 'package:ocx_mobile/bloc/auth/state.dart';
import 'package:ocx_mobile/bloc/signin/bloc.dart';
import 'package:ocx_mobile/bloc/wallet/bloc.dart';
import 'package:ocx_mobile/bloc/wallet/event.dart';
import 'package:ocx_mobile/repository/wallet_repository.dart';
import 'package:ocx_mobile/screens/auth/signin_screen.dart';
import 'package:ocx_mobile/screens/home/home_screen.dart';
import 'package:ocx_mobile/screens/loading_screen.dart';
import 'package:ocx_mobile/screens/onboarding/onboarding_screen.dart';

class AppWrapper extends StatelessWidget {
  AppWrapper({super.key});
  final EthereumWalletRepository ethereumWalletRepository =
      EthereumWalletRepository();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is OnboardingNotComplete) {
          return const OnboardingScreen();
        } else if (state is AuthenticationUnauthenticated) {
          return BlocProvider(
            create: (context) => SignInBloc(
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
              repository:
                  BlocProvider.of<AuthenticationBloc>(context).walletRepository,
            ),
            child: SignInScreen(),
          );
        } else if (state is AuthenticationAuthenticated) {
          return BlocProvider.value(
            value: BlocProvider.of<WalletBloc>(context)..add(Fetch()),
            child: const HomeScreen(),
          );
        } else {
          return const LoadingScreen();
        }
      },
    );
  }
}
