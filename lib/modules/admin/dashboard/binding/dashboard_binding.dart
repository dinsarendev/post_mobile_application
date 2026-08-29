import 'package:get/get.dart';
import 'package:post_mobile_application/modules/admin/dashboard/controller/dashboard_controller.dart';

class DashboardBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> DashboardController());
  }

}