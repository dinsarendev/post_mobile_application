import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:post_mobile_application/modules/admin/dashboard/controller/dashboard_controller.dart';
import 'package:post_mobile_application/routes/app_route_name.dart';
import 'package:post_mobile_application/widgets/appbar_custom_widget.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppbarCustomWidget(title: "Dashboard"),
        body: Container(
          padding: EdgeInsets.all(10),
          child: GridView.builder(
            itemCount: controller.menuList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              var menu = controller.menuList[index];
              return GestureDetector(
                onTap: (){
                  Get.toNamed(menu.routeName??AppRouteName.adminDashboard);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.cyan,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Center(
                    child: Text(
                      "${menu.nameEn}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
