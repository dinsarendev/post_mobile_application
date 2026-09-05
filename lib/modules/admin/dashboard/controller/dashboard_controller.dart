import 'package:get/get.dart';
import 'package:post_mobile_application/modules/admin/dashboard/models/menu.dart';

class DashboardController extends GetxController{
  var menuList = <Menu>[].obs;


  @override
  void onInit() {
    menuList.value = Menu.getAllMenus();
    super.onInit();
  }
}