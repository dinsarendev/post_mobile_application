import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:post_mobile_application/modules/admin/post/controller/post_controller.dart';
import 'package:post_mobile_application/widgets/appbar_custom_widget.dart';

class PostView extends GetView<PostController> {
  const PostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppbarCustomWidget(title: "List Posts"),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: controller.dataLoading.value == true
              ? Center(child: CircularProgressIndicator(color: Colors.cyan))
              : RefreshIndicator(
                  onRefresh: () async {
                    controller.getAllPosts();
                  },
                  child: ListView.builder(
                    itemCount: controller.postList.length,
                    itemBuilder: (context, index) {
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
                            SizedBox(
                              width: double.infinity,
                              child: Text("${data.description}"),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ),
      );
    });
  }
}
