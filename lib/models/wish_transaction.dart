import 'package:isar/isar.dart';

part 'wish_transaction.g.dart';

@collection
class WishTransaction {
  Id id = Isar.autoIncrement;

  late double amount;
  late int wishId;
  late DateTime date;

  WishTransaction({
    required this.amount,
    required this.wishId,
    required this.date,
  });
}
