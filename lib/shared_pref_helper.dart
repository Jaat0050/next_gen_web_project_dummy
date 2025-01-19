import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static final SharedPreferencesHelper _instance =
  SharedPreferencesHelper._ctor();

  factory SharedPreferencesHelper() {
    return _instance;
  }

  SharedPreferencesHelper._ctor();

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> isLoggedIn() async {
    return _prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<void> saveUserDetails(String name, String mobileNumber, String email, String user_id) async {
    await _prefs.setString('name', name);
    await _prefs.setString('mobileNumber', mobileNumber);
    await _prefs.setString('email', email);
    await _prefs.setString('user_id', user_id);
  }

  static String getUserName() {
    return _prefs.getString('name') ?? '';
  }

  static String getUserMobileNumber() {
    return _prefs.getString('mobileNumber') ?? '';
  }

  static String getUserEmail() {
    return _prefs.getString('email') ?? '';
  }

  static String getUserId() {
    return _prefs.getString('user_id') ?? '';
  }


// static void setAccessToken({required String accessToken}) {
//   _prefs.setString("accesstoken", accessToken);
// }
//
// static String getAccessToken() {
//   return _prefs.getString("accesstoken") ?? "";
// }
}
