import 'package:get_storage/get_storage.dart';

class AccessTokenStorage {
  static final _storage = GetStorage();
  static const String _accessToken = "ACCESS_TOKEN";
  static const String _refreshToken = "REFRESH_TOKEN";
  static const String _userId = "USER_ID";

  static setAccessToken(String token) => _storage.write(_accessToken, token);
  static getAccessToken() => _storage.read(_accessToken) ?? "";
  static setRefreshToken(String refresh) =>
      _storage.write(_refreshToken, refresh);
  static getRefreshToken() => _storage.read(_refreshToken) ?? "";
  static setUserId(int id) => _storage.write(_userId, id);
  static int? getUserId() => _storage.read<int>(_userId);
  static clearTokens() {
    _storage.remove(_accessToken);
    _storage.remove(_refreshToken);
    _storage.remove(_userId);
  }
}
