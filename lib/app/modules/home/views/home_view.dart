import 'package:fitness_project/app/modules/home/controllers/home_controller.dart';
import 'package:fitness_project/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HomePageView extends GetView<HomePageController> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF004AAD), // Deep blue color
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Kettlebell with heartbeat icon
              Container(
                width: 150,
                height: 150,
                child: Image.asset('assets/logo.png'), // Green color
              ),
              SizedBox(height: 60),
              Text(
                'Start Tracking, It\'s easy!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                  onPressed: () => Get.toNamed(Routes.PERSONAL_DETAILS),
                  child: Text('Sign Up For Free'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4CAF50),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () => Get.toNamed(Routes.LOGIN),
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}