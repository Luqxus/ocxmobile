import 'package:ocx_mobile/models/money.dart';
import 'package:web3dart/web3dart.dart';

class WalletModel {
  final Money _balance;
  final List<Transaction> _transactions;
  final EthereumAddress _address;
  WalletModel(this._balance, this._transactions, this._address);

  get balance => _balance;

  get transaction => _transactions;

  get address => _address;
}

class Transaction {}
