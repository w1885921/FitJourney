import 'package:fitness_project/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:fitness_project/app/api/api_calls.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final ApiService _apiService = ApiService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final email = ''.obs;
  final password = ''.obs;
  final isLoading = false.obs;

  Future<void> login() async {
    if (email.value.isEmpty || password.value.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading.value = true;
      await _apiService.login(
        email: email.value,
        password: password.value,
      );
      Get.offAllNamed(Routes.BE_FIT);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
