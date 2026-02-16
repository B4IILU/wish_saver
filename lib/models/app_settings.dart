import 'package:isar/isar.dart';

part 'app_settings.g.dart';

@collection
class AppSettings {
  Id id = 0; // всегда одна запись

  bool isDarkTheme = false;

  String locale = 'en';
}
