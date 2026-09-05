import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:post_mobile_application/constants/url_constant.dart';
import 'package:post_mobile_application/core/api/api_service.dart';
import 'package:post_mobile_application/core/models/post/Content.dart';
import 'package:post_mobile_application/core/models/post/CreatePostRequest.dart';
import 'package:post_mobile_application/core/models/post/PostCategory.dart';
import 'package:post_mobile_application/core/models/post/PostCategoryListResponse.dart';
import 'package:post_mobile_application/core/models/post/PostResponse.dart';
import 'package:post_mobile_application/core/models/post/UpdatePostRequest.dart';

class PostController extends GetxController {
  static const int pageSize = 10;

  final ApiService apiService;
  var dataLoading = false.obs;
  var loadingMore = false.obs;
  var formLoading = false.obs;
  var uploadingImage = false.obs;
  var postList = <Content>[].obs;
  var categories = <PostCategory>[].obs;
  var currentPage = 0.obs;
  var hasMore = true.obs;
  var searchKeyword = "".obs;

  final searchController = TextEditingController();
  final scrollController = ScrollController();
  Timer? _searchDebounce;

  PostController({required this.apiService});

  Future<void> getAllPosts({bool reset = true}) async {
    var page = reset ? 0 : currentPage.value + 1;
    if (reset) {
      dataLoading.value = true;
    } else {
      loadingMore.value = true;
    }
    var keyword = searchKeyword.value.trim();
    var keywordParam = keyword.isNotEmpty ? "&keyword=${Uri.encodeQueryComponent(keyword)}" : "";
    var response = await apiService.get(
      "${UrlConstants.adminListPostPath}?page=$page&size=$pageSize&status=ACT$keywordParam",
    );
    dataLoading.value = false;
    loadingMore.value = false;
    if (response != null) {
      var responseBody = PostResponse.fromJson(jsonDecode(response));
      var content = responseBody.data?.content ?? [];
      if (reset) {
        postList.value = content;
      } else {
        postList.addAll(content);
      }
      currentPage.value = page;
      hasMore.value = !(responseBody.data?.last ?? true);
    }
  }

  Future<void> loadMore() async {
    if (dataLoading.value || loadingMore.value || !hasMore.value) return;
    await getAllPosts(reset: false);
  }

  void onSearchChanged(String keyword) {
    searchKeyword.value = keyword;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      if (scrollController.hasClients) {
        scrollController.jumpTo(0);
      }
      getAllPosts(reset: true);
    });
  }

  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      loadMore();
    }
  }

  Future<void> loadCategories() async {
    var response = await apiService.get(
      "${UrlConstants.adminPostCategoryListPath}?status=ACT",
    );
    if (response != null) {
      var responseBody = PostCategoryListResponse.fromJson(jsonDecode(response));
      categories.value = responseBody.data ?? [];
    }
  }

  Future<bool> createPost({
    required String title,
    required String description,
    required String body,
    required String image,
    required int categoryId,
    required List<String> tags,
  }) async {
    formLoading.value = true;
    var result = await apiService.post(
      UrlConstants.adminListPostPath,
      CreatePostRequest(
        title: title,
        description: description,
        body: body,
        image: image,
        categoryId: categoryId,
        tags: tags,
      ).toJson(),
    );
    formLoading.value = false;
    if (result != null) {
      await getAllPosts(reset: true);
      return true;
    }
    return false;
  }

  Future<bool> updatePost({
    required int id,
    required String title,
    required String description,
    required String image,
    required int categoryId,
  }) async {
    formLoading.value = true;
    var result = await apiService.put(
      "${UrlConstants.adminListPostPath}/$id",
      UpdatePostRequest(
        title: title,
        description: description,
        image: image,
        categoryId: categoryId,
      ).toJson(),
    );
    formLoading.value = false;
    if (result != null) {
      await getAllPosts(reset: true);
      return true;
    }
    return false;
  }

  Future<String?> uploadPostImage({required List<int> bytes, required String filename}) async {
    uploadingImage.value = true;
    var url = await apiService.uploadImage(bytes: bytes, filename: filename);
    uploadingImage.value = false;
    return url;
  }

  Future<bool> deletePost(int id) async {
    var success = await apiService.delete("${UrlConstants.adminListPostPath}/$id");
    if (success) {
      await getAllPosts(reset: true);
    }
    return success;
  }

  @override
  void onInit() {
    getAllPosts();
    loadCategories();
    scrollController.addListener(_onScroll);
    super.onInit();
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }
}
