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

  Future<void> persistEmailAndSecretKey({
    required String email,
    required String secretKey,
  }) async {
    await _storage.write(key: _emailKey, value: email);
    await _storage.write(key: _secretKey, value: secretKey);
  }

  Future<Wallet> getWallet() async {
    String? value = await _storage.read(key: _balanceKey);

    Wallet wallet = Wallet(Money.fromBigString(value!), []);

    return wallet;
  }

  Future<void> setBalance(Money money) async {
    await _storage.write(key: _balanceKey, value: money.value.toString());
  }

  Future<bool> hasEmail() async {
    String? email = await _storage.read(key: _emailKey);
    return email != null;
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

  Future<bool> hasSecretKey() async {
    String? token = await _storage.read(key: _secretKey);
    return token != null;
  }

  Future<String?> getEmail() async {
    return _storage.read(key: _emailKey);
  }

  Future<String?> getSecretKey() async {
    return _storage.read(key: _secretKey);
  }

  Future<void> deleteEmail() async {
    await _storage.delete(key: _emailKey);
  }

  Future<void> deleteSecretKey() async {
    await _storage.delete(key: _secretKey);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
