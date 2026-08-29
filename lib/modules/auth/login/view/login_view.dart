import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends GetView<LoginView> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 35, horizontal: 16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 45),
              child: Text(
                textAlign: TextAlign.center,
                "Login",
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.cyan),
                  ),
                  hintText: "Username",
                  labelText: "Username",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.cyan),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(),
                  border: OutlineInputBorder(),
                  hintText: "Password",
                  labelText: "Password",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
