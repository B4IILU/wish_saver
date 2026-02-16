// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get russian => 'Russian';

  @override
  String get english => 'English';

  @override
  String get appTitle => 'Wish Saver';

  @override
  String get theme => 'Theme';

  @override
  String get language => 'Language';

  @override
  String get history => 'History';

  @override
  String get contact => 'Contacts';

  @override
  String get priceMustBePositive => 'Price must be greater than 0';

  @override
  String get newTarget => 'New Target';

  @override
  String get name => 'Name';

  @override
  String get price => 'Price (zł)';

  @override
  String get url => 'Product link (optional)';

  @override
  String get save => 'Save';

  @override
  String get congratulation => 'Congratulations';

  @override
  String get freeMoneyWhere => 'Where to allocate free money';

  @override
  String get withdrawFromFreeMoney => 'Withdraw some amount';

  @override
  String get withdrawFreeMoneyTitle => 'How much to withdraw from free money?';

  @override
  String get withdrawAmountLabel => 'Amount (zł)';

  @override
  String get withdraw => 'Withdraw';

  @override
  String get amountMustBeGreaterThanZero => 'Amount must be greater than 0';

  @override
  String get notEnoughFreeMoney => 'Not enough free money';

  @override
  String get noTargets => 'No available targets';

  @override
  String get cancel => 'Cancel';

  @override
  String get myTargets => 'My Targets';

  @override
  String get noTargetsNow => 'No targets yet';

  @override
  String get wrongUrl => 'Failed to open the link';

  @override
  String get moneyWhere =>
      'The target will be deleted. Where should the money be moved?';

  @override
  String get deleteTargetQQ => 'Delete target?';

  @override
  String get toFreeMoney => 'To free money';

  @override
  String get toAnotherTarget => 'To another target';

  @override
  String get deleteTarget => 'Delete target';

  @override
  String get noMoreTargets => 'No other targets';

  @override
  String get chooseTarget => 'Choose a target';

  @override
  String get transactionsHistory => 'Top-up History';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get addTarget => 'Add Target';

  @override
  String get done => 'Complete';

  @override
  String get editTarget => 'Edit Target';

  @override
  String get addPlace => 'Ad will be here';

  @override
  String get freeMoney => 'Free Money';

  @override
  String progressText(Object current, Object target) {
    return 'Saved: $current / $target zł';
  }

  @override
  String get historyTitle => 'History';

  @override
  String get showAll => 'Show all';

  @override
  String get targetCompleted => 'Target completed';

  @override
  String get saveToHistory => 'Save to history';

  @override
  String get openStore => 'Open store';

  @override
  String get addAmount => 'Add amount (zł)';

  @override
  String get add => 'Add';

  @override
  String get completedTargets => 'Completed targets';

  @override
  String get noCompletedTargets => 'No completed targets yet';

  @override
  String get completedAt => 'Completed on';
}
