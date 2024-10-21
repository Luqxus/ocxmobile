import 'dart:math';
import 'dart:typed_data';
// import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:ocx_mobile/models/money.dart';

import 'package:ocx_mobile/models/wallet.dart' hide Transaction;
import 'package:ocx_mobile/service/secure_storage.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

abstract class WalletRepository {
  // Future<Credentials> createWallet();
  Future<void> createWallet(String pin);

  Future<WalletModel> getWallet();

  Future<void> signTransaction(
      {required String value, required String to, required String pin});

  Future<void> sendTransaction({required String tx});
}

class DefaultWalletRepository implements WalletRepository {
  final SecureStorage _secureStorage = SecureStorage();

  final String _apiUrl = "https://sepolia-rpc.scroll.io";

  Future<void> createWallet(String pin) async {
    // Creates a cryptographically secure random number generator.
    var rng = Random.secure();

    // Creates a new, random private key from the [random] number generator.
    EthPrivateKey prKey = EthPrivateKey.createRandom(rng);

    Wallet wallet = Wallet.createNew(prKey, pin, rng);

    // persit wallet in encrypted storage
    _secureStorage.persistWallet(wallet.toJson());
  }

  Future<WalletModel> getWallet() async {
    Money balance = await _secureStorage.getBalance();
    List<String> transactions = await _secureStorage.getTransactions();
    String address = await _secureStorage.getAddress();

    return WalletModel(
      balance,
      List.of([]),
      EthereumAddress.fromHex(address),
    );
  }

  // Future<EthereumAddress> getAddress() async {
  //   String? hex = await _secureStorage.getWallet();

  //   // Parses a private key from a hexadecimal representation.
  //   Wallet wallet = Wallet.fromJson(hex, password);

  //   /// get [EthereumAddress] from credentials
  //   var address = fromHex.address;

  //   /// return [EthereumAddress]
  //   return address;
  // }

  @override
  Future<void> signTransaction(
      {required String value, required String to, required String pin}) async {
    Wallet wallet = await _getWallet(pin);

    EthereumAddress address = wallet.privateKey.address;

    final int nonce = await _secureStorage.getNonce();

    Transaction tx = Transaction(
      from: address,
      to: EthereumAddress.fromHex(to),
      gasPrice: EtherAmount.inWei(BigInt.one),
      maxGas: 3000000,
      value: EtherAmount.fromBase10String(
        EtherUnit.ether,
        value,
      ),
      nonce: nonce,
    );

    Credentials credentials = wallet.privateKey;

    Uint8List signedTx = signTransactionRaw(tx, credentials, chainId: 534351);

    String serializedTx = hex.encode(signedTx);

    await _secureStorage.incrementNonce();

    _secureStorage.persistPendingTxs(serializedTx);
  }

  @override
  Future<void> sendTransaction({required String tx}) async {
    final client = Web3Client(_apiUrl, Client());

    String txHash =
        await client.sendRawTransaction(Uint8List.fromList(hex.decode(tx)));
    print('Transaction Hash: $txHash');
  }

  // @override
  // Future<int> getNonce() async {
  //   EthereumAddress address = await _getAddress();

  //   // create client
  //   Web3Client client = Web3Client(_apiUrl, Client());

  //   // get transaction count from address
  //   return await client.getTransactionCount(address); // Set the correct nonce
  // }

  Future<Wallet> _getWallet(String pin) async {
    // get wallet
    String? hex = await _secureStorage.getWallet();

    // Parses a private key from a hexadecimal representation.
    Wallet wallet = Wallet.fromJson(hex!, pin);

    return wallet;
  }
}
