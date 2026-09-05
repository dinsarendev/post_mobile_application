import 'package:get_storage/get_storage.dart';

class SettingsStorage {
  static final _storage = GetStorage();
  static const String _darkMode = "DARK_MODE";

  static setDarkMode(bool value) => _storage.write(_darkMode, value);
  static bool getDarkMode() => _storage.read<bool>(_darkMode) ?? false;
}
