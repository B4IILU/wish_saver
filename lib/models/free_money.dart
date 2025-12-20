import 'package:isar/isar.dart';

part 'free_money.g.dart';

@collection
class FreeMoney {
  Id id = Isar.autoIncrement;

  double amount = 0;
}
