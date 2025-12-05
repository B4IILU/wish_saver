import 'package:hive/hive.dart';

part 'wish.g.dart';

@HiveType(typeId: 0)
class Wish {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double targetAmount;

  @HiveField(3)
  double savedAmount;

  @HiveField(4)
  String? storeUrl; //shoplink
  

  Wish({
    required this.id,
    required this.title,
    required this.targetAmount,
    this.savedAmount = 0,
    this.storeUrl,
  });
}