import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ocx_mobile/models/money.dart';
import 'package:ocx_mobile/models/wallet.dart';

class SecureStorage {
  static SecureStorage? _instance;

  factory SecureStorage() =>
      _instance ??= SecureStorage._(const FlutterSecureStorage());

  SecureStorage._(this._storage);

  final FlutterSecureStorage _storage;
  static const _secretKey = "SECRET_KEY";
  static const _emailKey = "EMAIL";
  static const _nonceKey = "NONCE";
  static const _balanceKey = "BALANCE";
  static const _walletKey = "WALLET";
  static const _txKey = "TRANSACTIONS";
  // Future<void> persistEmailAndSecretKey({
  //   required String email,
  //   required String secretKey,
  // }) async {
  //   await _storage.write(key: _emailKey, value: email);
  //   await _storage.write(key: _secretKey, value: secretKey);
  // }

  Future<String?> getWallet() async {
    String? value = await _storage.read(key: _walletKey);

    return value;
  }

  Future<void> persistWallet(String wallet) async {
    await _storage.write(key: _walletKey, value: wallet);
  }

  Future<void> persistPendingTxs(String tx) async {
    // Retrieve the existing list of transactions
    String? transactionsJson = await _storage.read(key: _txKey);
    List<String> transactions = [];

    if (transactionsJson != null) {
      // Decode the existing list if it exists
      transactions = List<String>.from(json.decode(transactionsJson));
    }

    // Add the new transaction to the list
    transactions.add(tx);

    // Save the updated list back to secure storage
    await _storage.write(
      key: _txKey,
      value: json.encode(transactions),
    );
  }

  Future<void> setBalance(Money money) async {
    await _storage.write(key: _balanceKey, value: money.value.toString());
  }

  Future<Money> getBalance() async {
    String? m = await _storage.read(key: _balanceKey);

    return Money.fromBigString(m!);
  }

  Future<void> setNonce(int nonce) async {
    await _storage.write(key: _nonceKey, value: nonce.toString());
  }

  Future<int> getNonce() async {
    String? nonce = await _storage.read(key: _nonceKey);

    return int.parse(nonce!);
  }

  Future<void> incrementNonce() async {
    String? nonce = await _storage.read(key: _nonceKey);

    int _n = int.parse(nonce!);

    await setNonce(_n + 1);
  }

  Future<bool> hasWallet() async {
    String? wallet = await _storage.read(key: _walletKey);
    return wallet != null;
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
