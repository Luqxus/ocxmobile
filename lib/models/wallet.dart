import 'package:ocx_mobile/models/money.dart';

class Wallet {
  final Money _balance;
  final List<Transaction> _transactions;

  Wallet(this._balance, this._transactions);

  get balance => _balance;

  get transaction => _transactions;
}

class Transaction {}
