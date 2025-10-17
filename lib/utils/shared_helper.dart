import 'package:shared_preferences/shared_preferences.dart';

class StorageKeys {
  StorageKeys._();
  static const isLoggedIn = 'is_logged_in';
  static const userName = 'user_name';
  static const userEmail = 'user_email';
  static const lastLogin = 'last_login_date';
}

class StorageHelper {
  StorageHelper._internal();
  static final StorageHelper instance = StorageHelper._internal();

  late final SharedPreferences _pref;
  bool _ready = false;

  static Future<void> init() async {
    final helper = StorageHelper.instance;
    helper._pref = await SharedPreferences.getInstance();
    helper._ready = true;
  }

  void _assertReady() {
    if (!_ready) {
      throw StateError(
        'StorageHelper belum di-init. Panggil StorageHelper.init() di main().',
      );
    }
  }

  Future<bool> setString(String k, String v) async {
    _assertReady();
    return _pref.setString(k, v);
  }

  String getString(String k, {String defaultValue = ''}) {
    _assertReady();
    return _pref.getString(k) ?? defaultValue;
  }

  Future<bool> setBool(String k, bool v) async {
    _assertReady();
    return _pref.setBool(k, v);
  }

  bool getBool(String k, {bool defaultValue = false}) {
    _assertReady();
    return _pref.getBool(k) ?? defaultValue;
  }

  Future<bool> remove(String k) async {
    _assertReady();
    return _pref.remove(k);
  }

  // ---- Auth shortcuts
  Future<void> loginDummy({required String name, required String email}) async {
    await setString(StorageKeys.userName, name);
    await setString(StorageKeys.userEmail, email);
    await setBool(StorageKeys.isLoggedIn, true);
    await setString(StorageKeys.lastLogin, DateTime.now().toIso8601String());
  }

  Future<void> logout() async {
    await remove(StorageKeys.isLoggedIn);
    await remove(StorageKeys.userName);
    await remove(StorageKeys.userEmail);
  }

  bool isLoggedIn() => getBool(StorageKeys.isLoggedIn);
  String get userName => getString(StorageKeys.userName, defaultValue: 'User');
  String get userEmail => getString(StorageKeys.userEmail, defaultValue: '-');
}
