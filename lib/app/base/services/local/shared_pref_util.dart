import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtil {

  late SharedPreferences _sharedPreferences;

  static final SharedPrefUtil _localStorageUtil = SharedPrefUtil._internal();

  factory SharedPrefUtil() {
    return _localStorageUtil;
  }

  SharedPrefUtil._internal() {
    init();
  }

  init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<String?> getString(String key) async =>Future(() => _sharedPreferences.getString(key));

  Future setString(String key, String value) async {
    await _sharedPreferences.setString(key, value);
  }

  Future removeKey(String key) async {
    await _sharedPreferences.remove(key);
  }
}