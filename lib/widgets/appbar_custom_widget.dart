import 'package:flutter/material.dart';

class AppbarCustomWidget extends StatelessWidget implements PreferredSizeWidget{
  Color? backgroundColor;
  String? title;
  AppbarCustomWidget({super.key, this.title, this.backgroundColor});
  // 1. Override preferredSize to define the height of the AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Custom height
  @override
  Widget build(BuildContext context) {
    return  AppBar(
      iconTheme: IconThemeData(
          color: Colors.white
      ),
      backgroundColor:backgroundColor ??  Colors.cyan,
      title: Text(title??"", style: TextStyle(color: Colors.white),),
    );
  }
}
