// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get russian => 'Русский';

  @override
  String get english => 'English';

  @override
  String get appTitle => 'Копилка хотелок';

  @override
  String get theme => 'Тема';

  @override
  String get language => 'Язык';

  @override
  String get history => 'История';

  @override
  String get contact => 'Контакты';

  @override
  String get priceMustBePositive => 'Цена должна быть больше 0';

  @override
  String get newTarget => 'Новая цель';

  @override
  String get name => 'Название';

  @override
  String get price => 'Цена (zł)';

  @override
  String get url => 'Ссылка на товар (необязательно)';

  @override
  String get save => 'Сохранить';

  @override
  String get congratulation => 'Поздравляю';

  @override
  String get freeMoneyWhere => 'Куда распределить свободные деньги';

  @override
  String get withdrawFromFreeMoney => 'Просто забрать часть';

  @override
  String get withdrawFreeMoneyTitle => 'Сколько забрать из свободных денег?';

  @override
  String get withdrawAmountLabel => 'Сумма (zł)';

  @override
  String get withdraw => 'Забрать';

  @override
  String get amountMustBeGreaterThanZero => 'Сумма должна быть больше 0';

  @override
  String get notEnoughFreeMoney => 'Недостаточно свободных денег';

  @override
  String get noTargets => 'Нет доступных целей';

  @override
  String get cancel => 'Отмена';

  @override
  String get myTargets => 'Мои цели';

  @override
  String get noTargetsNow => 'Пока нет целей';

  @override
  String get wrongUrl => 'Не удалось открыть ссылку';

  @override
  String get moneyWhere => 'Цель будет удалена. Куда перенести деньги?';

  @override
  String get deleteTargetQQ => 'Удалить цель?';

  @override
  String get toFreeMoney => 'В свободные деньги';

  @override
  String get toAnotherTarget => 'В другую цель';

  @override
  String get deleteTarget => 'Удалить цель';

  @override
  String get noMoreTargets => 'Нет других целей';

  @override
  String get chooseTarget => 'Выберите цель';

  @override
  String get transactionsHistory => 'История пополнений';

  @override
  String get delete => 'Удалить';

  @override
  String get edit => 'Редактировать';

  @override
  String get addTarget => 'Добавить цель';

  @override
  String get done => 'Завершить';

  @override
  String get editTarget => 'Редактировать цель';

  @override
  String get addPlace => 'Тут будет реклама';

  @override
  String get freeMoney => 'Свободные деньги';

  @override
  String progressText(Object current, Object target) {
    return 'Накоплено: $current / $target zł';
  }

  @override
  String get historyTitle => 'История';

  @override
  String get showAll => 'Показать все';

  @override
  String get targetCompleted => 'Цель выполнена';

  @override
  String get saveToHistory => 'Записать в историю';

  @override
  String get openStore => 'Открыть магазин';

  @override
  String get addAmount => 'Добавить сумму (zł)';

  @override
  String get add => 'Добавить';

  @override
  String get completedTargets => 'Выполненные цели';

  @override
  String get noCompletedTargets => 'Пока нет выполненных целей';

  @override
  String get completedAt => 'Завершена';
}
