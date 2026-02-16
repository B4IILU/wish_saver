import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wish_saver/models/app_settings.dart';
import 'package:wish_saver/models/completed_wish.dart';
import 'package:wish_saver/models/free_money.dart';
import 'package:wish_saver/models/wish.dart';
import 'package:wish_saver/models/wish_transaction.dart';

class IsarService {
  static Isar? _isar;
  static Future<Isar>? _opening;

  static Future<Isar> get instance {
    if (_isar != null) return Future.value(_isar);
    _opening ??= _open();
    return _opening!;
  }

  static Future<Isar> _open() async {
    final dir = await getApplicationDocumentsDirectory();

    final isar = await Isar.open(
      [
        WishSchema,
        WishTransactionSchema,
        FreeMoneySchema,
        AppSettingsSchema,
        CompletedWishSchema,
      ],
      directory: dir.path,
      name: 'wish_saver_db',
      inspector: true,
    );

    await _ensureSingleSettings(isar);

    _isar = isar;
    return isar;
  }

  /// 🔥 ГАРАНТИЯ ОДНОЙ ЗАПИСИ
  static Future<void> _ensureSingleSettings(Isar isar) async {
    final existing = await isar.appSettings.get(0);

    if (existing != null) return;

    // Получаем системную локаль
    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;

    // Используем языковой код, но если это не 'en' или 'ru', по умолчанию 'en'
    final locale = systemLocale.languageCode == 'ru' ? 'ru' : 'en';

    await isar.writeTxn(() async {
      await isar.appSettings.put(
        AppSettings()
          ..id = 0
          ..locale = locale,
      );
    });

    print(
      '🆕 CREATED default settings locale = $locale (system: ${systemLocale.languageCode})',
    );
  }
}
