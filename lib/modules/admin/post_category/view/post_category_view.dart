import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:post_mobile_application/core/models/post/PostCategory.dart';
import 'package:post_mobile_application/modules/admin/post_category/controller/post_category_controller.dart';
import 'package:post_mobile_application/modules/admin/post_category/view/post_category_form_view.dart';
import 'package:post_mobile_application/widgets/app_snackbar.dart';
import 'package:post_mobile_application/widgets/appbar_custom_widget.dart';

class PostCategoryView extends GetView<PostCategoryController> {
  const PostCategoryView({super.key});

  Future<void> _onDeleteTap(BuildContext context, PostCategory data) async {
    var confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Category"),
        content: Text("Are you sure you want to delete \"${data.name}\"? This cannot be undone."),
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
      var success = await controller.deleteCategory(data.id!);
      if (success) {
        AppSnackbar.success("Category deleted successfully");
      } else {
        AppSnackbar.error("Failed to delete category");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppbarCustomWidget(title: "Categories"),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.cyan,
          onPressed: () => Get.to(() => const PostCategoryFormView()),
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: controller.dataLoading.value
            ? const Center(child: CircularProgressIndicator(color: Colors.cyan))
            : RefreshIndicator(
                onRefresh: () async => controller.getAllCategories(),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: controller.categoryList.length,
                  itemBuilder: (context, index) {
                    var data = controller.categoryList[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 72,
                            height: 72,
                            child: (data.imageUrl != null && data.imageUrl!.isNotEmpty)
                                ? Image.network(data.imageUrl!, fit: BoxFit.cover)
                                : Container(color: Colors.black26),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data.name ?? "", style: const TextStyle(fontSize: 16)),
                                  const SizedBox(height: 4),
                                  Text(
                                    data.status == "ACT" ? "Active" : "Inactive",
                                    style: TextStyle(
                                      color: data.status == "ACT" ? Colors.green : Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, color: Colors.cyan),
                            onPressed: () => Get.to(() => PostCategoryFormView(editingCategory: data)),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () => _onDeleteTap(context, data),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
      );
    });
  }
}
