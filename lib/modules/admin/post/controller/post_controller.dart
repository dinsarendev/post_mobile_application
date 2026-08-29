import 'dart:convert';

import 'package:get/get.dart';
import 'package:post_mobile_application/constants/url_constant.dart';
import 'package:post_mobile_application/core/api/api_service.dart';
import 'package:post_mobile_application/core/models/post/Content.dart';
import 'package:post_mobile_application/core/models/post/PostResponse.dart';

class PostController extends GetxController {
  final ApiService apiService;
  var dataLoading = false.obs;
  var postList = <Content>[].obs;

  PostController({required this.apiService});

  Future<void> getAllPosts() async {
    dataLoading.value = true;
    var response = await apiService.get(
      "${UrlConstants.adminListPostPath}?page=0&size=100&status=ACT",
    );
    dataLoading.value = false;
    var responseBody = PostResponse.fromJson(jsonDecode(response));
    if (responseBody.data != null) {
      print("${responseBody.toJson()}");
      postList.value = responseBody.data!.content ?? [];
    }
  }

  @override
  void onInit() {
    getAllPosts();
    super.onInit();
  }
}
