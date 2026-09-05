import 'package:get/get.dart';
import 'package:post_mobile_application/core/api/api_service.dart';
import 'package:post_mobile_application/core/api/api_service_impl.dart';
import 'package:post_mobile_application/modules/admin/post_category/controller/post_category_controller.dart';

class PostCategoryBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(()=> ApiServiceImpl());
    Get.lazyPut(()=> PostCategoryController(apiService: Get.find<ApiService>()));
  }

}
