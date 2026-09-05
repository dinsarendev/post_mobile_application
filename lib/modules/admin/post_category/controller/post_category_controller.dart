import 'dart:convert';

import 'package:get/get.dart';
import 'package:post_mobile_application/constants/url_constant.dart';
import 'package:post_mobile_application/core/api/api_service.dart';
import 'package:post_mobile_application/core/models/post/PostCategory.dart';
import 'package:post_mobile_application/core/models/post/PostCategoryListResponse.dart';
import 'package:post_mobile_application/core/models/post/PostCategoryRequest.dart';

class PostCategoryController extends GetxController {
  final ApiService apiService;
  var dataLoading = false.obs;
  var formLoading = false.obs;
  var uploadingImage = false.obs;
  var categoryList = <PostCategory>[].obs;

  PostCategoryController({required this.apiService});

  Future<void> getAllCategories() async {
    dataLoading.value = true;
    var response = await apiService.get(
      "${UrlConstants.adminPostCategoryListPath}?status=ACT",
    );
    dataLoading.value = false;
    if (response != null) {
      var responseBody = PostCategoryListResponse.fromJson(jsonDecode(response));
      categoryList.value = responseBody.data ?? [];
    }
  }

  Future<bool> createCategory({
    required String name,
    required String imageUrl,
    required String status,
  }) async {
    formLoading.value = true;
    var result = await apiService.post(
      UrlConstants.adminPostCategoryListPath,
      PostCategoryRequest(name: name, imageUrl: imageUrl, status: status).toJson(),
    );
    formLoading.value = false;
    if (result != null) {
      await getAllCategories();
      return true;
    }
    return false;
  }

  Future<bool> updateCategory({
    required int id,
    required String name,
    required String imageUrl,
    required String status,
  }) async {
    formLoading.value = true;
    var result = await apiService.put(
      "${UrlConstants.adminPostCategoryListPath}/$id",
      PostCategoryRequest(name: name, imageUrl: imageUrl, status: status).toJson(),
    );
    formLoading.value = false;
    if (result != null) {
      await getAllCategories();
      return true;
    }
    return false;
  }

  Future<bool> deleteCategory(int id) async {
    var success = await apiService.delete("${UrlConstants.adminPostCategoryListPath}/$id");
    if (success) {
      await getAllCategories();
    }
    return success;
  }

  Future<String?> uploadCategoryImage({required List<int> bytes, required String filename}) async {
    uploadingImage.value = true;
    var url = await apiService.uploadImage(bytes: bytes, filename: filename);
    uploadingImage.value = false;
    return url;
  }

  @override
  void onInit() {
    getAllCategories();
    super.onInit();
  }
}
