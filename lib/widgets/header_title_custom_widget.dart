import 'package:flutter/material.dart';

class HeaderTitleCustomWidget extends StatelessWidget {
  String? title;
  HeaderTitleCustomWidget({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: double.infinity,
      child: Text(
        textAlign: TextAlign.center,
        title??"",
        style: TextStyle(color: Colors.black, fontSize: 24),
      ),
    );
  }
}
