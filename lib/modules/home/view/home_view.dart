import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:post_mobile_application/modules/article/view/article_detail_view.dart';
import 'package:post_mobile_application/modules/home/controller/home_controller.dart';
import 'package:post_mobile_application/routes/app_route_name.dart';
import 'package:post_mobile_application/widgets/app_choice_chip.dart';
import 'package:post_mobile_application/widgets/appbar_custom_widget.dart';
import 'package:post_mobile_application/widgets/input_form_custom.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  Future<void> _onLogoutTap(BuildContext context) async {
    var confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text("Logout", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await controller.onLogout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        drawer: Drawer(
          backgroundColor: Colors.cyan,
          child: ListView(
            children: [
              SizedBox(
                height: 150,
              ),
              ListTile(
                onTap: (){
                  Navigator.pop(context);
                  Get.toNamed(AppRouteName.adminDashboard);
                },
                leading: Icon(Icons.dashboard, color: Colors.white,),
                title: Text("Dashboard", style: TextStyle(color: Colors.white),),
              ),
              ListTile(
                onTap: (){
                  Navigator.pop(context);
                  Get.toNamed(AppRouteName.settings);
                },
                leading: Icon(Icons.settings, color: Colors.white,),
                title: Text("Settings", style: TextStyle(color: Colors.white),),
              ),
              ListTile(
                onTap: (){
                  Navigator.pop(context);
                  _onLogoutTap(context);
                },
                leading: Icon(Icons.logout, color: Colors.white,),
                title: Text("Logout", style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        appBar: AppbarCustomWidget(
          title: "Home",
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              InputFormCustom(
                controller: controller.searchController,
                labelText: "Search",
                hintText: "Search articles by title...",
                prefixIcon: Icons.search,
                onChanged: controller.onSearchChanged,
              ),
              if (controller.categories.isNotEmpty)
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      AppChoiceChip(
                        label: "All",
                        selected: controller.selectedCategoryId.value == null,
                        onTap: () => controller.onCategorySelected(null),
                      ),
                      ...controller.categories.map(
                        (category) => AppChoiceChip(
                          label: category.name ?? "",
                          selected: controller.selectedCategoryId.value == category.id,
                          onTap: () => controller.onCategorySelected(category.id),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              Expanded(
                child: controller.dataLoading.value == true
                    ? const Center(child: CircularProgressIndicator(color: Colors.cyan))
                    : controller.articleList.isEmpty
                        ? Center(
                            child: Text(
                              "No articles found",
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              await controller.getArticles(reset: true);
                            },
                            child: ListView.builder(
                              controller: controller.scrollController,
                              itemCount: controller.articleList.length +
                                  (controller.loadingMore.value ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index >= controller.articleList.length) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Center(
                                      child: CircularProgressIndicator(color: Colors.cyan),
                                    ),
                                  );
                                }
                                var data = controller.articleList[index];
                                return InkWell(
                                  onTap: () => Get.to(
                                    () => ArticleDetailView(articleId: data.id!, initial: data),
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if ((data.image ?? "").isNotEmpty)
                                          Image.network(
                                            data.image!,
                                            width: double.infinity,
                                            height: 160,
                                            fit: BoxFit.cover,
                                          ),
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              if (data.postCategory?.name != null)
                                                Container(
                                                  margin: const EdgeInsets.only(bottom: 6),
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.cyan.shade50,
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  child: Text(
                                                    data.postCategory!.name!,
                                                    style: const TextStyle(
                                                      color: Colors.cyan,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              Text(
                                                data.title ?? "",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                data.description ?? "",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(color: Colors.grey.shade700),
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Icon(Icons.visibility_outlined,
                                                      size: 14, color: Colors.grey.shade600),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    "${data.views ?? 0}",
                                                    style: TextStyle(
                                                        color: Colors.grey.shade600, fontSize: 12),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Icon(Icons.thumb_up_alt_outlined,
                                                      size: 14, color: Colors.grey.shade600),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    "${data.reactions?.likes ?? 0}",
                                                    style: TextStyle(
                                                        color: Colors.grey.shade600, fontSize: 12),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Icon(Icons.thumb_down_alt_outlined,
                                                      size: 14, color: Colors.grey.shade600),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    "${data.reactions?.dislikes ?? 0}",
                                                    style: TextStyle(
                                                        color: Colors.grey.shade600, fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
