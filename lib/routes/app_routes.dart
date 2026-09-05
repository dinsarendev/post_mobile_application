import 'package:get/get.dart';
import 'package:post_mobile_application/modules/admin/dashboard/binding/dashboard_binding.dart';
import 'package:post_mobile_application/modules/admin/dashboard/view/dashboard_view.dart';
import 'package:post_mobile_application/modules/admin/post/binding/post_binding.dart';
import 'package:post_mobile_application/modules/admin/post/view/post_view.dart';
import 'package:post_mobile_application/modules/admin/post_category/binding/post_category_binding.dart';
import 'package:post_mobile_application/modules/admin/post_category/view/post_category_view.dart';
import 'package:post_mobile_application/modules/auth/login/binding/login_binding.dart';
import 'package:post_mobile_application/modules/auth/login/view/login_view.dart';
import 'package:post_mobile_application/modules/auth/register/binding/register_binding.dart';
import 'package:post_mobile_application/modules/auth/register/view/register_view.dart';
import 'package:post_mobile_application/modules/auth/forgot_password/binding/forgot_password_binding.dart';
import 'package:post_mobile_application/modules/auth/forgot_password/view/forgot_password_view.dart';
import 'package:post_mobile_application/modules/home/binding/home_binding.dart';
import 'package:post_mobile_application/modules/home/view/home_view.dart';
import 'package:post_mobile_application/modules/splash/binding/splash_binding.dart';
import 'package:post_mobile_application/modules/splash/view/splash_view.dart';
import 'package:post_mobile_application/routes/app_route_name.dart';

class AppRoutes{
  AppRoutes._();
  static List<GetPage> getAllRoutes(){
    return [
      GetPage(name: AppRouteName.splash, page: ()=> SplashView(), binding: SplashBinding()),
      GetPage(name: AppRouteName.home, page: ()=> HomeView(), binding: HomeBinding()),
      GetPage(name: AppRouteName.login, page: ()=> LoginView(), binding: LoginBinding()),
      GetPage(name: AppRouteName.register, page: ()=> RegisterView(), binding: RegisterBinding()),
      GetPage(name: AppRouteName.forgotPassword, page: ()=> ForgotPasswordView(), binding: ForgotPasswordBinding()),
      GetPage(name: AppRouteName.adminDashboard, page: ()=> DashboardView(), binding: DashboardBinding()),
      GetPage(name: AppRouteName.adminPost, page: ()=> PostView(), binding: PostBinding()),
      GetPage(name: AppRouteName.adminPostCategory, page: ()=> PostCategoryView(), binding: PostCategoryBinding()),
    ];
  }
}