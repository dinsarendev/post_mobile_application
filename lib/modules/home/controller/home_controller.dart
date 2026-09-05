import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:post_mobile_application/constants/url_constant.dart';
import 'package:post_mobile_application/core/api/api_service.dart';
import 'package:post_mobile_application/core/models/post/Content.dart';
import 'package:post_mobile_application/core/models/post/PostCategory.dart';
import 'package:post_mobile_application/core/models/post/PostCategoryListResponse.dart';
import 'package:post_mobile_application/core/models/post/PostResponse.dart';
import 'package:post_mobile_application/routes/app_route_name.dart';
import 'package:post_mobile_application/widgets/app_snackbar.dart';

class HomeController extends GetxController {
  static const int pageSize = 10;

  final ApiService apiService;
  HomeController({required this.apiService});

  var loggingOut = false.obs;

  var dataLoading = false.obs;
  var loadingMore = false.obs;
  var articleList = <Content>[].obs;
  var categories = <PostCategory>[].obs;
  var selectedCategoryId = Rx<int?>(null);
  var currentPage = 0.obs;
  var hasMore = true.obs;
  var searchKeyword = "".obs;

  final searchController = TextEditingController();
  final scrollController = ScrollController();
  Timer? _searchDebounce;

  Future<void> getArticles({bool reset = true}) async {
    var page = reset ? 0 : currentPage.value + 1;
    if (reset) {
      dataLoading.value = true;
    } else {
      loadingMore.value = true;
    }
    var keyword = searchKeyword.value.trim();
    var keywordParam = keyword.isNotEmpty ? "&keyword=${Uri.encodeQueryComponent(keyword)}" : "";
    var categoryParam = selectedCategoryId.value != null ? "&categoryId=${selectedCategoryId.value}" : "";
    var response = await apiService.get(
      "${UrlConstants.publicPostListPath}?page=$page&size=$pageSize&status=ACT$keywordParam$categoryParam",
    );
    dataLoading.value = false;
    loadingMore.value = false;
    if (response != null) {
      var responseBody = PostResponse.fromJson(jsonDecode(response));
      var content = responseBody.data?.content ?? [];
      if (reset) {
        articleList.value = content;
      } else {
        articleList.addAll(content);
      }
      currentPage.value = page;
      hasMore.value = !(responseBody.data?.last ?? true);
    }
  }

  Future<void> loadMore() async {
    if (dataLoading.value || loadingMore.value || !hasMore.value) return;
    await getArticles(reset: false);
  }

  void onSearchChanged(String keyword) {
    searchKeyword.value = keyword;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      if (scrollController.hasClients) {
        scrollController.jumpTo(0);
      }
      getArticles(reset: true);
    });
  }

  void onCategorySelected(int? categoryId) {
    if (selectedCategoryId.value == categoryId) return;
    selectedCategoryId.value = categoryId;
    if (scrollController.hasClients) {
      scrollController.jumpTo(0);
    }
    getArticles(reset: true);
  }

  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      loadMore();
    }
  }

  Future<void> loadCategories() async {
    var response = await apiService.get("${UrlConstants.publicPostCategoryListPath}?status=ACT");
    if (response != null) {
      var responseBody = PostCategoryListResponse.fromJson(jsonDecode(response));
      categories.value = responseBody.data ?? [];
    }
  }

  Future<void> onLogout() async {
    loggingOut.value = true;
    await apiService.logout();
    loggingOut.value = false;
    AppSnackbar.success("Logged out successfully");
    Get.offAllNamed(AppRouteName.login);
  }

  @override
  void onInit() {
    getArticles();
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
