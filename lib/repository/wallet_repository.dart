// import 'dart:io';
// import 'dart:typed_data';

// import 'package:ocx_mobile/models/money.dart';
// import 'package:ocx_mobile/service/secure_storage.dart';
// import 'package:web3auth_flutter/enums.dart';
// import 'package:web3auth_flutter/input.dart';
// import 'package:web3auth_flutter/output.dart';
// import 'package:web3auth_flutter/web3auth_flutter.dart';
// import 'package:web3dart/web3dart.dart';
// import 'package:convert/convert.dart';
// import 'package:ocx_mobile/models/wallet.dart' as wallet;

// import 'package:http/http.dart';

// abstract class WalletRepository {
//   Future<String> signIn({required String email});
//   Future<String> signTransaction({
//     required String value,
//     required String to,
//   });

//   Future<List<String>> createWallet();

//   Future<void> sendTransaction({required String tx});

//   Future<String> getPrivKey();

//   Future<String> getAddress();

//   Future<int> getNonce();

//   Future<wallet.Wallet> getWallet();

//   Future<Money> getBalance();

//   Future<void> setBalance(Money money);
// }

// class EthereumWalletRepository implements WalletRepository {
//   final String _apiUrl = "https://sepolia-rpc.scroll.io";
//   final SecureStorage _secureStorage = SecureStorage();

//   @override
//   Future<String> getPrivKey() async {
//     return await Web3AuthFlutter.getPrivKey();
//   }

//   @override
//   Future<String> signIn({required String email}) async {
//     print(email);
//     await _initWeb3Auth();

//     final Web3AuthResponse response = await Web3AuthFlutter.login(LoginParams(
//         loginProvider: Provider.email_passwordless,
//         extraLoginOptions: ExtraLoginOptions(login_hint: email)));

//     return response.privKey!;
//   }

//   Future<void> _initWeb3Auth() async {
//     Uri redirectUrl;

//     if (Platform.isAndroid) {
//       redirectUrl = Uri.parse('w3a://com.example.ocx/auth');

//       // w3a://com.example.w3aflutter/auth
//     } else if (Platform.isIOS) {
//       redirectUrl = Uri.parse('{bundleId}://auth');
//       // com.example.w3aflutter://openlogin
//     } else {
//       throw UnKnownException('Unknown platform');
//     }

//     String WEB3AUTH_CLIENT_ID =
//         "BMDfYtS2wQA1TTb2Z9R_G4bzQoKH-ctvG2P8wZHFGfYwiKwu5WdiudyQHD6NKlhW733f27ZuJnfnCMMnFxTweuQ";

//     try {
//       await Web3AuthFlutter.init(
//         Web3AuthOptions(
//           clientId: WEB3AUTH_CLIENT_ID,
//           network: Network.sapphire_devnet,
//           redirectUrl: redirectUrl,
//         ),
//       );
//     } catch (e) {
//       print(e.toString());
//     }

//     await Web3AuthFlutter.initialize();
//   }

//   @override
//   Future<wallet.Wallet> getWallet() async {
//     await getBalance();
//     return await _secureStorage.getWallet();
//   }

//   @override
//   Future<String> signTransaction(
//       {required String value, required String to}) async {
//     EthPrivateKey credentials = await _getPrivKey();
//     EthereumAddress address = credentials.address;
//     final int nonce = await _secureStorage.getNonce();

//     Transaction tx = Transaction(
//       from: address,
//       to: EthereumAddress.fromHex(to),
//       gasPrice: EtherAmount.inWei(BigInt.one),
//       maxGas: 3000000,
//       value: EtherAmount.fromBase10String(
//         EtherUnit.wei,
//         "1000000",
//       ),
//       nonce: nonce,
//     );

//     Uint8List signedTx = signTransactionRaw(tx, credentials, chainId: 534351);

//     String serializedTx = hex.encode(signedTx);

//     await _secureStorage.incrementNonce();

//     return serializedTx;
//   }

//   @override
//   Future<void> sendTransaction({required String tx}) async {
//     final client = Web3Client(_apiUrl, Client());

//     String txHash =
//         await client.sendRawTransaction(Uint8List.fromList(hex.decode(tx)));
//     print('Transaction Hash: $txHash');
//   }

//   /// get the nonce of the current transaction by [EthereumAddress]
//   @override
//   Future<int> getNonce() async {
//     EthereumAddress address = await _getAddress();

//     // create client
//     Web3Client client = Web3Client(_apiUrl, Client());

//     // get transaction count from address
//     return await client.getTransactionCount(address); // Set the correct nonce
//   }

//   @override
//   Future<Money> getBalance() async {
//     Web3Client client = Web3Client(_apiUrl, Client());
//     EthereumAddress address = await _getAddress();
//     EtherAmount amount = await client.getBalance(address);

//     BigInt v = amount.getInWei;
//     Money m = Money(v);

//     _secureStorage.setBalance(m);

//     return m;
//   }

//   @override
//   Future<String> getAddress() async {
//     EthereumAddress address = await _getAddress();

//     return address.hexEip55;
//   }

//   @override
//   Future<void> setBalance(Money money) async {
//     await _secureStorage.setBalance(money);
//   }

//   /// get [EthereumAddress] from [EthPrivateKey]
//   Future<EthereumAddress> _getAddress() async {
//     // get privKey
//     EthPrivateKey privKey = await _getPrivKey();

//     // get address from privKey
//     return privKey.address;
//   }

//   /// get [EthPrivateKey]
//   Future<EthPrivateKey> _getPrivKey() async {
//     // get privKey string from secure storage
//     String? privKey = await _secureStorage.getSecretKey();

//     /// [EthPrivateKey] from string privKey
//     EthPrivateKey credentials = EthPrivateKey.fromHex(privKey!);

//     /// [EthPrivateKey]
//     return credentials;
//   }
// }
