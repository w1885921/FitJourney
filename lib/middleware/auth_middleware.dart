import 'package:fitness_project/app/api/api_calls.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final ApiService _apiService = ApiService(); // Ensure AuthService is initialized
    final currentUser = _apiService.currentUser;
    if (currentUser!.isVerified == 0) {
      Future.microtask(() => Get.offAndToNamed('/verification-code')); // Fixes navigator conflict
      return null; // Prevents multiple navigator instances // Redirect to login
    }
    return null; // Allow access if verified
  }
}
