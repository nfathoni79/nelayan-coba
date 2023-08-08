import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  SharedPreferences? _prefs;

  SharedPreferences? get prefs => _prefs;

  Future<SharedPreferences?> getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs;
  }

  Future<String?> getAccessToken() async {
    await getPrefs();
    return _prefs!.getString('accessToken');
  }

  Future<String?> getRefreshToken() async {
    await getPrefs();
    return _prefs!.getString('refreshToken');
  }

  Future<String?> getLastDepositUuid() async {
    await getPrefs();
    return _prefs!.getString('lastDepositUuid');
  }

  Future<String?> getLastWithdrawalUuid() async {
    await getPrefs();
    return _prefs!.getString('lastWithdrawalUuid');
  }

  Future setTokens(String accessToken, String refreshToken) async {
    await getPrefs();
    _prefs!.setString('accessToken', accessToken);
    _prefs!.setString('refreshToken', refreshToken);
  }

  Future setLastDepositUuid(String uuid) async {
    await getPrefs();
    _prefs!.setString('lastDepositUuid', uuid);
  }

  Future setLastWithdrawalUuid(String uuid) async {
    await getPrefs();
    _prefs!.setString('lastWithdrawalUuid', uuid);
  }
}