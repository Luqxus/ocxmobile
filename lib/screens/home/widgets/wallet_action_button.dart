// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ocx_mobile/bloc/transfer/bloc.dart';
// import 'package:ocx_mobile/bloc/wallet/bloc.dart';
// import 'package:ocx_mobile/repository/wallet_repository.dart';
// import 'package:ocx_mobile/screens/common/colors.dart';
// import 'package:ocx_mobile/screens/transfer/bloc/bloc.dart';
// import 'package:ocx_mobile/screens/transfer/receive_screen.dart';
// import 'package:ocx_mobile/screens/transfer/transfer_screen.dart';

// class WalletActionButtons extends StatelessWidget {
//   const WalletActionButtons({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         // pay action button
//         WalletActionButtonsItem(
//           icon: Icons.arrow_upward_rounded,
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => MultiBlocProvider(
//                   providers: [
//                     BlocProvider(
//                       create: (context) =>
//                           TransferBloc(EthereumWalletRepository()),
//                     ),
//                     BlocProvider(
//                       create: (context) => TxTypeBloc(),
//                     ),
//                   ],
//                   child: const TransferScreen(),
//                 ),
//               ),
//             );
//           },
//           label: "Pay",
//         ),

//         // receive action button
//         WalletActionButtonsItem(
//           icon: Icons.arrow_downward_rounded,
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => MultiBlocProvider(
//                   providers: [
//                     BlocProvider(
//                       create: (context) =>
//                           TransferBloc(EthereumWalletRepository()),
//                     ),
//                     BlocProvider(
//                       create: (context) => TxTypeBloc(),
//                     ),
//                   ],
//                   child: const ReceiveScreen(),
//                 ),
//               ),
//             );
//           },
//           label: "Receive",
//         ),

//         // deposit action button
//         WalletActionButtonsItem(
//           icon: Icons.attach_money_rounded,
//           onPressed: () {},
//           label: "Deposit",
//         ),
//       ],
//     );
//   }
// }

// class WalletActionButtonsItem extends StatelessWidget {
//   const WalletActionButtonsItem({
//     super.key,
//     required this.icon,
//     required this.onPressed,
//     required this.label,
//   });

//   final IconData icon;
//   final VoidCallback onPressed;
//   final String label;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         CircleAvatar(
//           radius: 32,
//           child: InkWell(
//             onTap: onPressed,
//             child: Icon(
//               icon,
//               color: textPrimary,
//             ),
//           ),
//         ),
//         const SizedBox(
//           height: 4.0,
//         ),
//         Text(
//           label,
//           style: TextStyle(color: textSecondary),
//         ),
//       ],
//     );
//   }
// }
