import 'package:web3dart/web3dart.dart';

class Money {
  final BigInt value;

  Money(this.value);

  factory Money.fromDouble(double number) {
    var value = BigInt.from(number * 100);
    return Money(value);
  }

  Money subtract(Money money) {
    BigInt v = value - money.value;
    return Money(v);
  }

  factory Money.fromBigString(String value) {
    BigInt v = BigInt.parse(value);

    return Money(v);
  }

  Money add(Money money) {
    BigInt v = value + money.value;
    return Money(v);
  }

  @override
  String toString() {
    // Convert BigInt to Ether and get it in double
    BigInt v = EtherAmount.fromBigInt(EtherUnit.wei, value).getInEther;

    // Multiply by the current ETH to USD rate (e.g., 2300.00)
    double usdValue = v.toDouble() * 2300.00 * 17.5;

    // Return the USD value as a formatted string with two decimal places
    return usdValue.toStringAsFixed(2);
  }
}
