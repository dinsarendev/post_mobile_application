import 'package:get/get.dart';
import 'package:post_mobile_application/modules/auth/login/binding/login_binding.dart';
import 'package:post_mobile_application/modules/auth/login/view/login_view.dart';
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
    ];
  }
}