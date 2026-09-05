class UrlConstants {
  UrlConstants._();
  static const String baseUrl = "http://10.3.1.176:30033";
  static const String loginPath = "$baseUrl/api/oauth/token";
  static const String registerPath = "$baseUrl/api/oauth/register";
  static const String refreshTokenPath = "$baseUrl/api/oauth/refresh";
  static const String logoutPath = "$baseUrl/api/oauth/logout";
  static const String forgotPasswordPath = "$baseUrl/api/oauth/forgot/password";
  static const String forgotPasswordVerifyPath = "$baseUrl/api/oauth/forgot/password/verify";
  static const String forgotPasswordFinishPath = "$baseUrl/api/oauth/forgot/password/finish";
  static const String adminListPostPath = "$baseUrl/api/app/post";
  static const String adminPostCategoryListPath = "$baseUrl/api/app/post/category";
  static const String imageUploadPath = "$baseUrl/api/oauth/image/upload";
  static const String updateProfilePath = "$baseUrl/api/app/user/update";
  static const String changePasswordPath = "$baseUrl/api/app/user/change/password";
  static String userByIdPath(int id) => "$baseUrl/api/app/user/$id";
  static const String publicPostListPath = "$baseUrl/api/public/post";
  static const String publicPostCategoryListPath = "$baseUrl/api/public/post-category";
  static String publicPostDetailPath(int id) => "$baseUrl/api/public/post/$id";
  static String publicPostLikePath(int id) => "$baseUrl/api/public/post/$id/like";
  static String publicPostDislikePath(int id) => "$baseUrl/api/public/post/$id/dislike";
}