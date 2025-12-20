import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../models/wish.dart';
import '../models/wish_transaction.dart';
import '../models/free_money.dart';

class IsarService {
  static Isar? _isar;

  static Future<Isar> get instance async {
    if (_isar != null) return _isar!;

    final dir = await getApplicationDocumentsDirectory();

    // path_provider may return Directory but on some platforms it returns other types,
    // ensure it's a Directory path string:
    final dirPath = dir.path;

    _isar = await Isar.open(
      [
        WishSchema,
        WishTransactionSchema,
        FreeMoneySchema,
      ],
      directory: dirPath,
    );

    return _isar!;
  }
}
