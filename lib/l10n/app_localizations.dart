import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// Название языка русский
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get russian;

  /// Название языка английский
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Название приложения
  ///
  /// In en, this message translates to:
  /// **'Wish Saver'**
  String get appTitle;

  /// Настройка темы приложения
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Настройка языка приложения
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Раздел истории
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// Раздел связи
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contact;

  /// Ошибка если цена меньше или равна нулю
  ///
  /// In en, this message translates to:
  /// **'Price must be greater than 0'**
  String get priceMustBePositive;

  /// Заголовок создания новой цели
  ///
  /// In en, this message translates to:
  /// **'New Target'**
  String get newTarget;

  /// Поле названия цели
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Поле цены цели
  ///
  /// In en, this message translates to:
  /// **'Price (zł)'**
  String get price;

  /// Поле ссылки на товар
  ///
  /// In en, this message translates to:
  /// **'Product link (optional)'**
  String get url;

  /// Кнопка сохранения
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Заголовок при завершении цели
  ///
  /// In en, this message translates to:
  /// **'Congratulations'**
  String get congratulation;

  /// Диалог распределения свободных денег
  ///
  /// In en, this message translates to:
  /// **'Where to allocate free money'**
  String get freeMoneyWhere;

  /// Remove part of free money without moving to target
  ///
  /// In en, this message translates to:
  /// **'Withdraw some amount'**
  String get withdrawFromFreeMoney;

  /// Dialog title for withdrawing amount from free money
  ///
  /// In en, this message translates to:
  /// **'How much to withdraw from free money?'**
  String get withdrawFreeMoneyTitle;

  /// Amount field label for free money withdrawal
  ///
  /// In en, this message translates to:
  /// **'Amount (zł)'**
  String get withdrawAmountLabel;

  /// Confirm withdrawal from free money
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdraw;

  /// Validation error for non-positive amount
  ///
  /// In en, this message translates to:
  /// **'Amount must be greater than 0'**
  String get amountMustBeGreaterThanZero;

  /// Validation error when amount exceeds free money
  ///
  /// In en, this message translates to:
  /// **'Not enough free money'**
  String get notEnoughFreeMoney;

  /// Сообщение если целей нет
  ///
  /// In en, this message translates to:
  /// **'No available targets'**
  String get noTargets;

  /// Кнопка отмены
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Заголовок главного экрана
  ///
  /// In en, this message translates to:
  /// **'My Targets'**
  String get myTargets;

  /// Сообщение если пока нет созданных целей
  ///
  /// In en, this message translates to:
  /// **'No targets yet'**
  String get noTargetsNow;

  /// Ошибка открытия URL
  ///
  /// In en, this message translates to:
  /// **'Failed to open the link'**
  String get wrongUrl;

  /// Диалог переноса денег перед удалением цели
  ///
  /// In en, this message translates to:
  /// **'The target will be deleted. Where should the money be moved?'**
  String get moneyWhere;

  /// Подтверждение удаления цели
  ///
  /// In en, this message translates to:
  /// **'Delete target?'**
  String get deleteTargetQQ;

  /// Перенести деньги в свободные
  ///
  /// In en, this message translates to:
  /// **'To free money'**
  String get toFreeMoney;

  /// Перенести деньги в другую цель
  ///
  /// In en, this message translates to:
  /// **'To another target'**
  String get toAnotherTarget;

  /// Кнопка удаления цели
  ///
  /// In en, this message translates to:
  /// **'Delete target'**
  String get deleteTarget;

  /// Сообщение если нет других целей для переноса
  ///
  /// In en, this message translates to:
  /// **'No other targets'**
  String get noMoreTargets;

  /// Выбор цели для переноса денег
  ///
  /// In en, this message translates to:
  /// **'Choose a target'**
  String get chooseTarget;

  /// Заголовок истории транзакций
  ///
  /// In en, this message translates to:
  /// **'Top-up History'**
  String get transactionsHistory;

  /// Кнопка удаления
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Кнопка редактирования
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Кнопка добавления цели
  ///
  /// In en, this message translates to:
  /// **'Add Target'**
  String get addTarget;

  /// Кнопка завершения цели
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get done;

  /// Заголовок редактирования цели
  ///
  /// In en, this message translates to:
  /// **'Edit Target'**
  String get editTarget;

  /// Заглушка рекламного блока
  ///
  /// In en, this message translates to:
  /// **'Ad will be here'**
  String get addPlace;

  /// Раздел свободных денег
  ///
  /// In en, this message translates to:
  /// **'Free Money'**
  String get freeMoney;

  /// Текст прогресса накопления
  ///
  /// In en, this message translates to:
  /// **'Saved: {current} / {target} zł'**
  String progressText(Object current, Object target);

  /// Transactions history title
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// Show all transactions button
  ///
  /// In en, this message translates to:
  /// **'Show all'**
  String get showAll;

  /// Completed target label
  ///
  /// In en, this message translates to:
  /// **'Target completed'**
  String get targetCompleted;

  /// Save to history button
  ///
  /// In en, this message translates to:
  /// **'Save to history'**
  String get saveToHistory;

  /// Open store button
  ///
  /// In en, this message translates to:
  /// **'Open store'**
  String get openStore;

  /// Add amount field label
  ///
  /// In en, this message translates to:
  /// **'Add amount (zł)'**
  String get addAmount;

  /// Add button
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Completed targets history screen title
  ///
  /// In en, this message translates to:
  /// **'Completed targets'**
  String get completedTargets;

  /// Empty state for completed targets history
  ///
  /// In en, this message translates to:
  /// **'No completed targets yet'**
  String get noCompletedTargets;

  /// Completed date label
  ///
  /// In en, this message translates to:
  /// **'Completed on'**
  String get completedAt;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
