import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:post_mobile_application/modules/admin/dashboard/controller/dashboard_controller.dart';
import 'package:post_mobile_application/widgets/appbar_custom_widget.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustomWidget(
        title: "Dashboard"
      ),
    );
  }
}
