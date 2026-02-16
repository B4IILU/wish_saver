import 'package:flutter/material.dart';
import 'package:wish_saver/l10n/app_localizations.dart';
import 'package:wish_saver/models/app_settings.dart';
import 'package:wish_saver/models/app_theme.dart';
import 'package:wish_saver/screens/home_screen.dart';
import 'package:wish_saver/services/app_settings_service.dart';
import 'package:wish_saver/services/wish_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settings = await AppSettingsService.loadOrCreateSettings();

  runApp(MyApp(initialSettings: settings));
}

class MyApp extends StatefulWidget {
  final AppSettings initialSettings;

  const MyApp({super.key, required this.initialSettings});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final WishService _wishService = WishService();

  late ThemeMode _themeMode;
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialSettings.isDarkTheme
        ? ThemeMode.dark
        : ThemeMode.light;
    _locale = Locale(widget.initialSettings.locale);
  }

  Future<void> _setLocale(Locale locale) async {
    await AppSettingsService.setLocale(locale.languageCode);
    setState(() => _locale = locale);
  }

  Future<void> _onThemeChanged(bool isDark) async {
    await AppSettingsService.setTheme(isDark);
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      themeMode: _themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: HomeScreen(
        wishService: _wishService,
        isDark: _themeMode == ThemeMode.dark,
        onThemeChanged: _onThemeChanged,
        onLocaleChanged: _setLocale,
      ),
    );
  }
}
