import 'package:isar/isar.dart';

import '../models/wish.dart';
import '../models/wish_transaction.dart';
import 'isar_service.dart';

class WishService {
  
   Future<List<Wish>> getWishes() async {
    final isar = await IsarService.instance;
    return await isar.wishs
        .where()
        .sortByCreatedAtDesc()
        .findAll();
  }

  Future<void> addWish({
    required String title,
    required double targetAmount,
    String? storeUrl,
  }) async {
    final isar = await IsarService.instance;

    final wish = Wish()
      ..title = title
      ..targetAmount = targetAmount
      ..currentAmount = 0
      ..storeUrl = storeUrl;

    await isar.writeTxn(() async {
      await isar.wishs.put(wish);
    });
  }

  Future<void> removeWish(int id) async {
    final isar = await IsarService.instance;

    await isar.writeTxn(() async {
      await isar.wishs.delete(id);
    });
  }

  Future<void> addMoneyToWish(int wishId, double amount) async {
    final isar = await IsarService.instance;

    await isar.writeTxn(() async {
      final wish = await isar.wishs.get(wishId);
      if (wish == null) return;

      wish.currentAmount += amount;
      await isar.wishs.put(wish);

      final tx = WishTransaction(
        amount: amount,
        wishId: wishId,
        date: DateTime.now(),
      );

      await isar.wishTransactions.put(tx);
    });
  }
}
