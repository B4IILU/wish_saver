import 'package:isar/isar.dart';

part 'free_money.g.dart';

@collection
class FreeMoney {
  Id id = 0; // всегда одна запись
  double amount = 0;
}
