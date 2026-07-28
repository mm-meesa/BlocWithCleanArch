


import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _accessTokenKey = 'access_token';
  static const String _emailKey = 'email';
  static const String _firstnameKey = 'firstname';
  static const String _lastnameKey = 'lastname';


  /// Save stored access token
  static Future<void> saveAccessToken({
    required String accessToken}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
  }

  /// Get stored access token
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }


  /// Clear all authentication data (logout)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_accessTokenKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_firstnameKey);
    await prefs.remove(_lastnameKey);
  }
}

