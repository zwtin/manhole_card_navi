import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class PreferencesDataSource {
  PreferencesDataSource(this._preferences);

  final StreamingSharedPreferences _preferences;

  Stream<String> watchString(String key) => _string(key);

  Stream<List<String>> watchStringList(String key) => _stringList(key);

  String readString(String key) => _string(key).getValue();

  List<String> readStringList(String key) => _stringList(key).getValue();

  Future<bool> writeString(String key, String value) {
    return _preferences.setString(key, value);
  }

  Future<bool> writeStringList(String key, List<String> value) {
    return _preferences.setStringList(key, value);
  }

  Preference<String> _string(String key) =>
      _preferences.getString(key, defaultValue: '');

  Preference<List<String>> _stringList(String key) =>
      _preferences.getStringList(key, defaultValue: const []);
}
