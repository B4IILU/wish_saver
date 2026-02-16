import 'package:isar/isar.dart';

part 'completed_wish.g.dart';

@collection
class CompletedWish {
  Id id = Isar.autoIncrement;

  late String title;
  late double targetAmount;
  late double savedAmount;

  String? storeUrl;

  late DateTime createdAt;
  late DateTime completedAt;
}
