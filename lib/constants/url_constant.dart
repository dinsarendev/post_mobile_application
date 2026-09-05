class UrlConstants {
  UrlConstants._();
  static const String baseUrl = "http://10.3.0.31:30033";
  static const String loginPath = "$baseUrl/api/oauth/token";
  static const String registerPath = "$baseUrl/api/oauth/register";
  static const String refreshTokenPath = "$baseUrl/api/oauth/refresh";
  static const String forgotPasswordPath = "$baseUrl/api/oauth/forgot/password";
  static const String forgotPasswordVerifyPath = "$baseUrl/api/oauth/forgot/password/verify";
  static const String forgotPasswordFinishPath = "$baseUrl/api/oauth/forgot/password/finish";
  static const String adminListPostPath = "$baseUrl/api/app/post";
  static const String adminPostCategoryListPath = "$baseUrl/api/app/post/category";
  static const String imageUploadPath = "$baseUrl/api/oauth/image/upload";
}