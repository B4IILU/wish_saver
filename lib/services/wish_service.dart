import 'package:hive_flutter/adapters.dart';
import 'package:uuid/uuid.dart';
import '../models/wish.dart';

class WishService {
  static const String boxName = 'wishes';
  final Uuid _uuid = const Uuid();

  Box<Wish> get _box => Hive.box<Wish>(boxName);

  List<Wish> get wishes => _box.values.toList();
  
  void addWish({
    required String title,
    required double targetAmount,
    String? storeUrl,
  }) {
    final wish = Wish(
      id: _uuid.v4(),
      title: title,
      targetAmount: targetAmount,
      storeUrl: storeUrl,
      );
    _box.add(wish);
  }

  // Добавить денег к конкретной цели
  void addMoneyToWish(String id, double amount) {
    final index = _box.values.toList().indexWhere((w) => w.id == id);
    if (index == -1) return;

    final wish = _box.getAt(index)!;
    wish.savedAmount += amount;
    _box.putAt(index, wish);
  }

  // Удалить цель
  void removeWish(String id) {
    final index = _box.values.toList().indexWhere((w) => w.id == id);
    if (index == -1) return;

    _box.deleteAt(index);
  }
}