import 'package:flutter/material.dart';

class ButtonCustomWidget extends StatelessWidget {
  Color? backgroundColor;
  String? title;
  VoidCallback? onClick;
  bool? loading;
  ButtonCustomWidget({
    super.key,
    this.backgroundColor,
    this.title,
    this.onClick,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.cyan,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 17),
        child: Center(
          child: loading==true ? CircularProgressIndicator(
            color: Colors.white,
          ) :
          Text(title ?? "", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
