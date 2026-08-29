import 'package:flutter/material.dart';

class InputFormCustom extends StatelessWidget {
  String? hintText, labelText;
  TextEditingController? controller;
  InputFormCustom({super.key, this.hintText, this.labelText, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.cyan),
          ),
          hintText: hintText ?? "",
          labelText: labelText ?? "",
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.cyan),
          ),
        ),
      ),
    );
  }
}
