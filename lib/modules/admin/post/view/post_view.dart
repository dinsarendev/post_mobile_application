import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:post_mobile_application/core/models/post/Content.dart';
import 'package:post_mobile_application/modules/admin/post/controller/post_controller.dart';
import 'package:post_mobile_application/modules/admin/post/view/post_form_view.dart';
import 'package:post_mobile_application/widgets/appbar_custom_widget.dart';
import 'package:post_mobile_application/widgets/input_form_custom.dart';

class PostView extends GetView<PostController> {
  const PostView({super.key});

  Future<void> _onDeleteTap(BuildContext context, Content data) async {
    var confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post"),
        content: Text("Are you sure you want to delete \"${data.title}\"? This cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text("Delete", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      var success = await controller.deletePost(data.id!);
      Get.snackbar(
        success ? "Success" : "Error",
        success ? "Post deleted successfully" : "Failed to delete post",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppbarCustomWidget(title: "List Posts"),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.cyan,
          onPressed: () => Get.to(() => const PostFormView()),
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              InputFormCustom(
                controller: controller.searchController,
                labelText: "Search",
                hintText: "Search posts by title...",
                prefixIcon: Icons.search,
                onChanged: controller.onSearchChanged,
              ),
              Expanded(
                child: controller.dataLoading.value == true
                    ? Center(child: CircularProgressIndicator(color: Colors.cyan))
                    : controller.postList.isEmpty
                        ? Center(
                            child: Text(
                              "No posts found",
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              await controller.getAllPosts(reset: true);
                            },
                            child: ListView.builder(
                              controller: controller.scrollController,
                              itemCount: controller.postList.length +
                                  (controller.loadingMore.value ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index >= controller.postList.length) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Center(
                                      child: CircularProgressIndicator(color: Colors.cyan),
                                    ),
                                  );
                                }
                                var data = controller.postList[index];
                                return Container(
                                  width: double.infinity,
                                  color: Colors.black12,
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    children: [
                                      Image.network("${data.image}"),
                                      SizedBox(
                                        width: double.infinity,
                                        child: Text(
                                          "${data.title}",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      if (data.postCategory?.name != null)
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            margin: const EdgeInsets.only(top: 4),
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                                        ),
                                      SizedBox(
                                        width: double.infinity,
                                        child: Text("${data.description}"),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit_outlined, color: Colors.cyan),
                                            onPressed: () =>
                                                Get.to(() => PostFormView(editingPost: data)),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                            onPressed: () => _onDeleteTap(context, data),
                                          ),
                                        ],
                                      ),
                                    ],
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
