import 'package:isar/isar.dart';

part 'wish.g.dart';

@collection
class Wish {
  Id id = Isar.autoIncrement;

  late String title;
  late double targetAmount;
  double currentAmount = 0;

  String? storeUrl;
  DateTime createdAt = DateTime.now();
}