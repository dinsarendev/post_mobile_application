class UrlConstants {
  UrlConstants._();
  static const String baseUrl = "http://localhost:30033";
  static const String loginPath = "$baseUrl/api/oauth/token";
  static const String refreshTokenPath = "$baseUrl/api/oauth/refresh";
}