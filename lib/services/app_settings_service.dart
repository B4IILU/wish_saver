import 'package:flutter/material.dart';
import 'package:wish_saver/l10n/app_localizations.dart';
import 'package:wish_saver/models/app_settings.dart';
import 'package:wish_saver/services/isar_service.dart';

class AppSettingsService {
  static Future<AppSettings> loadOrCreateSettings() async {
    final isar = await IsarService.instance;
    final existing = await isar.appSettings.get(0);

    if (existing != null) {
      return existing;
    }

    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
    final supportedLanguages =
        AppLocalizations.supportedLocales.map((l) => l.languageCode).toList();

    final locale = supportedLanguages.contains(systemLocale.languageCode)
        ? systemLocale.languageCode
        : 'en';

    final settings = AppSettings()
      ..id = 0
      ..locale = locale;

    await isar.writeTxn(() => isar.appSettings.put(settings));
    return settings;
  }

  static Future<void> updateSettings(
    AppSettings Function(AppSettings) updateFn,
  ) async {
    final isar = await IsarService.instance;
    final current = await isar.appSettings.get(0);
    if (current == null) return;

    final updated = updateFn(current);
    await isar.writeTxn(() => isar.appSettings.put(updated));
  }

  static Future<void> setLocale(String languageCode) =>
      updateSettings((s) => AppSettings()
        ..id = 0
        ..locale = languageCode
        ..isDarkTheme = s.isDarkTheme);

  static Future<void> setTheme(bool isDark) =>
      updateSettings((s) => AppSettings()
        ..id = 0
        ..locale = s.locale
        ..isDarkTheme = isDark);
}
