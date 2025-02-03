import 'package:flutter/material.dart';
import 'package:fitness_project/global/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatelessWidget {
  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueInternational,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: greenInternational,
                ),
              ),
            ),
            SizedBox(height: 100.h),

            // Email Field
            TextField(
              controller: controller.emailController,
              onChanged: (value) => controller.email.value = value,
              decoration: InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: greenInternational),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: greenInternational, width: 2),
                ),
              ),
            ),
            SizedBox(height: 30.h),

            // Password Field
            TextField(
              controller: controller.passwordController,
              onChanged: (value) => controller.password.value = value,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: greenInternational),
                ),
                helperStyle: TextStyle(color: greenInternational),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: greenInternational, width: 2),
                ),
              ),
            ),
            SizedBox(height: 24),

            // Login Button with Loading State
            Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.login(),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: greenInternational,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: controller.isLoading.value
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
