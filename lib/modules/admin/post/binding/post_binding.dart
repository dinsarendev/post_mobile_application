import 'package:get/get.dart';
import 'package:post_mobile_application/core/api/api_service.dart';
import 'package:post_mobile_application/core/api/api_service_impl.dart';
import 'package:post_mobile_application/modules/admin/post/controller/post_controller.dart';

class PostBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<ApiService>(()=> ApiServiceImpl());
    Get.lazyPut(()=> PostController(apiService: Get.find<ApiService>()));
  }

}