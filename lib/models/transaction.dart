import 'package:ocx_mobile/models/money.dart';

enum TransactionStatus { pending, success, failed }

class TransactionModel {
  final TransactionStatus status;
  final String from;
  final String to;
  final Money amount;
  final DateTime date;

  TransactionModel(
      {required this.amount,
      required this.date,
      required this.from,
      required this.status,
      required this.to});
}
