import 'package:wish_saver/models/free_money.dart';
import 'package:wish_saver/services/isar_service.dart';

class FreeMoneyService {
  Future<double> getAmount() async {
    final isar = await IsarService.instance;
    final fm = await isar.freeMoneys.get(0);
    return fm?.amount ?? 0;
  }

  Future<void> add(double amount) async {
    final isar = await IsarService.instance;

    await isar.writeTxn(() async {
      final fm = await isar.freeMoneys.get(0) ?? FreeMoney();
      fm.amount += amount;
      await isar.freeMoneys.put(fm);
    });
  }

  Future<void> subtract(double amount) async {
    final isar = await IsarService.instance;
    
    await isar.writeTxn(() async {
      final fm = await isar.freeMoneys.get(0);
      if (fm == null) return;

      fm.amount -= amount;
      if (fm.amount < 0) fm.amount = 0;
      await isar.freeMoneys.put(fm);
    });
  }
}
 