import 'package:isar/isar.dart';
import 'package:wish_saver/models/completed_wish.dart';
import 'package:wish_saver/models/free_money.dart';
import 'package:wish_saver/models/wish.dart';
import 'package:wish_saver/models/wish_transaction.dart';
import 'package:wish_saver/services/isar_service.dart';

class WishService {
  /// =============================
  /// ЗАГРУЗКА
  /// =============================

  Future<List<Wish>> getWishes() async {
    final isar = await IsarService.instance;
    return isar.wishs.where().sortByCreatedAtDesc().findAll();
  }

  /// =============================
  /// СОЗДАНИЕ
  /// =============================

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

  /// =============================
  /// ДОБАВЛЕНИЕ ДЕНЕГ
  /// =============================

  Future<void> addMoneyToWish(int wishId, double amount) async {
    final isar = await IsarService.instance;

    await isar.writeTxn(() async {
      final wish = await isar.wishs.get(wishId);
      if (wish == null) return;

      final availableSpace = wish.targetAmount - wish.currentAmount;

      double added = 0;
      double overflow = 0;

      if (availableSpace <= 0) {
        overflow = amount;
      } else if (amount <= availableSpace) {
        added = amount;
        wish.currentAmount += amount;
      } else {
        added = availableSpace;
        overflow = amount - availableSpace;
        wish.currentAmount = wish.targetAmount;
      }

      if (added > 0) {
        await isar.wishs.put(wish);

        await isar.wishTransactions.put(
          WishTransaction(wishId: wishId, amount: added, date: DateTime.now()),
        );
      }

      if (overflow > 0) {
        final fm = await isar.freeMoneys.get(0) ?? FreeMoney();
        fm.amount += overflow;
        await isar.freeMoneys.put(fm);
      }
    });
  }

  /// =============================
  /// ОБНОВЛЕНИЕ МЕТАДАННЫХ
  /// =============================

  Future<void> updateWishMeta({
    required int wishId,
    required String title,
    required double targetAmount,
    String? storeUrl,
  }) async {
    final isar = await IsarService.instance;

    await isar.writeTxn(() async {
      final wish = await isar.wishs.get(wishId);
      if (wish == null) return;

      if (targetAmount < wish.currentAmount) {
        final overflow = wish.currentAmount - targetAmount;
        wish.currentAmount = targetAmount;

        final fm = await isar.freeMoneys.get(0) ?? FreeMoney();
        fm.amount += overflow;
        await isar.freeMoneys.put(fm);
      }

      wish.title = title;
      wish.targetAmount = targetAmount;
      wish.storeUrl = storeUrl;

      await isar.wishs.put(wish);
    });
  }

  /// =============================
  /// УДАЛЕНИЕ ЦЕЛИ → FREEMONEY
  /// =============================

  Future<void> deleteWishToFreeMoney(int wishId) async {
    final isar = await IsarService.instance;

    await isar.writeTxn(() async {
      final wish = await isar.wishs.get(wishId);
      if (wish == null) return;

      if (wish.currentAmount > 0) {
        final fm = await isar.freeMoneys.get(0) ?? FreeMoney();
        fm.amount += wish.currentAmount;
        await isar.freeMoneys.put(fm);
      }

      await _deleteWishInternal(isar, wishId);
    });
  }

  /// =============================
  /// ЗАВЕРШЕНИЕ ЦЕЛИ
  /// =============================

  Future<void> completeWish(int wishId) async {
    final isar = await IsarService.instance;

    await isar.writeTxn(() async {
      final wish = await isar.wishs.get(wishId);
      if (wish == null) return;

      final completedWish = CompletedWish()
        ..title = wish.title
        ..targetAmount = wish.targetAmount
        ..savedAmount = wish.currentAmount
        ..storeUrl = wish.storeUrl
        ..createdAt = wish.createdAt
        ..completedAt = DateTime.now();

      await isar.completedWishs.put(completedWish);
      await _deleteWishInternal(isar, wishId);
    });
  }

  /// =============================
  /// УДАЛЕНИЕ БЕЗ ИСТОРИИ
  /// =============================

  Future<void> deleteWish(int wishId) async {
    final isar = await IsarService.instance;

    await isar.writeTxn(() async {
      await _deleteWishInternal(isar, wishId);
    });
  }

  /// =============================
  /// ПЕРЕНОС МЕЖДУ ЦЕЛЯМИ
  /// =============================

  Future<void> moveWishMoneyToAnotherWish({
    required int fromWishId,
    required int toWishId,
  }) async {
    final isar = await IsarService.instance;

    await isar.writeTxn(() async {
      final fromWish = await isar.wishs.get(fromWishId);
      final toWish = await isar.wishs.get(toWishId);
      if (fromWish == null || toWish == null) return;

      final amount = fromWish.currentAmount;
      if (amount <= 0) {
        await _deleteWishInternal(isar, fromWishId);
        return;
      }

      final availableSpace = toWish.targetAmount - toWish.currentAmount;

      double added = 0;
      double overflow = 0;

      if (availableSpace <= 0) {
        overflow = amount;
      } else if (amount <= availableSpace) {
        added = amount;
        toWish.currentAmount += amount;
      } else {
        added = availableSpace;
        overflow = amount - availableSpace;
        toWish.currentAmount = toWish.targetAmount;
      }

      if (added > 0) {
        await isar.wishs.put(toWish);
        await isar.wishTransactions.put(
          WishTransaction(
            wishId: toWishId,
            amount: added,
            date: DateTime.now(),
          ),
        );
      }

      if (overflow > 0) {
        final fm = await isar.freeMoneys.get(0) ?? FreeMoney();
        fm.amount += overflow;
        await isar.freeMoneys.put(fm);
      }

      await _deleteWishInternal(isar, fromWishId);
    });
  }

  /// =============================
  /// FREEMONEY → ЦЕЛЬ
  /// =============================

  Future<void> moveFreeMoneyToWish(int toWishId) async {
    final isar = await IsarService.instance;

    await isar.writeTxn(() async {
      final fm = await isar.freeMoneys.get(0);
      final wish = await isar.wishs.get(toWishId);
      if (fm == null || wish == null || fm.amount <= 0) return;

      final availableSpace = wish.targetAmount - wish.currentAmount;

      double added = 0;
      double overflow = 0;

      if (availableSpace <= 0) {
        overflow = fm.amount;
      } else if (fm.amount <= availableSpace) {
        added = fm.amount;
        wish.currentAmount += fm.amount;
      } else {
        added = availableSpace;
        overflow = fm.amount - availableSpace;
        wish.currentAmount = wish.targetAmount;
      }

      if (added > 0) {
        await isar.wishs.put(wish);
        await isar.wishTransactions.put(
          WishTransaction(
            wishId: toWishId,
            amount: added,
            date: DateTime.now(),
          ),
        );
      }

      fm.amount = overflow;
      await isar.freeMoneys.put(fm);
    });
  }

  /// =============================
  /// ИСТОРИЯ ВЫПОЛНЕННЫХ ЦЕЛЕЙ
  /// =============================

  Future<List<CompletedWish>> getCompletedWishes() async {
    final isar = await IsarService.instance;

    return isar.completedWishs.where().sortByCompletedAtDesc().findAll();
  }

  /// =============================
  /// ИСТОРИЯ ПОПОЛНЕНИЙ ПО ЦЕЛИ
  /// =============================

  Future<List<WishTransaction>> getWishTransactionHistory(int wishId) async {
    final isar = await IsarService.instance;

    return isar.wishTransactions
        .filter()
        .wishIdEqualTo(wishId)
        .sortByDateDesc()
        .findAll();
  }

  /// =============================
  /// ВНУТРЕННЕЕ КАСКАДНОЕ УДАЛЕНИЕ
  /// =============================

  Future<void> _deleteWishInternal(Isar isar, int wishId) async {
    await isar.wishTransactions.filter().wishIdEqualTo(wishId).deleteAll();

    await isar.wishs.delete(wishId);
  }
}
