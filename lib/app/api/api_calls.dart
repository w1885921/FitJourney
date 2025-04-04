// lib/services/api_service.dart

import 'package:dio/dio.dart';
import 'package:fitness_project/app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get_storage/get_storage.dart';


import '../routes/app_pages.dart';

class ApiService {
  final Dio _dio = Dio();
  final GetStorage _storage = GetStorage();
  final String baseUrl = 'http://172.20.10.2:8000/api'; // For Android Emulator
  // Use 'http://localhost:8000/api' for iOS simulator

  static const String TOKEN_KEY = 'auth_token';
  static const String USER_KEY = 'user_data';

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = _storage.read(TOKEN_KEY);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
          print('Bearer $token');
        }
        options.headers['Accept'] = 'application/json';
        return handler.next(options);
      },
    ));
  }

  // Check if user is logged in
  bool get isLoggedIn => _storage.hasData(TOKEN_KEY);

  // Get current user
  User? get currentUser {
    final userData = _storage.read(USER_KEY);
    return userData != null ? User.fromJson(userData) : null;
  }

  Future<User> register({
    required String fullName,
    required String email,
    required String password,
    required String dateOfBirth,
    required String mobileNumber,
    double? weight,
    double? height,
    String? gender,
  }) async {
    try {
      // Ensure date is in YYYY-MM-DD format before sending
      final formattedDate = _ensureMySQLDateFormat(dateOfBirth);

      final response = await _dio.post('$baseUrl/register', data: {
        'full_name': fullName,
        'email': email,
        'password': password,
        'date_of_birth': formattedDate,
        'mobile_number': mobileNumber,
        'weight': weight,
        'height': height,
        'gender': gender,
      });

      // Save token and user data
      await _storage.write(TOKEN_KEY, response.data['token']);
      await _storage.write(USER_KEY, response.data['user']);

      return User.fromJson(response.data['user']);
    } on DioException catch (e) {
      print(e.response);
      print("e.response");
      throw _handleError(e);
    }
  }

  Future<User> resendCode() async {
    try {
      // Ensure date is in YYYY-MM-DD format before sending
      final response = await _dio.post('$baseUrl/resend/code');
      await _storage.write(USER_KEY, response.data['user']);
      Get.snackbar("Success", "Code Resend",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Colors.white);
      await _storage.write(USER_KEY, response.data['user']);
      return User.fromJson(response.data['user']);
    } on DioException catch (e) {
      Get.snackbar("Error", "Code not sent",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      throw _handleError(e);
    }
  }

  // Update Calories
  Future<void> updateCalories(int calories) async {
    try {
      final response = await _dio.post('$baseUrl/daily-logs/update-calories', data: {
        "calories_consumed": calories,
      });

      if (response.statusCode == 200) {
        print("✅ Calories updated successfully!");
      } else {
        print("⚠️ Error updating calories: ${response.data}");
      }
    } catch (e) {
      print("❌ Dio error: $e");
    }
  }

  Future<bool> sendEmailVerification(String verification_code) async {
    try {
      final response = await _dio.post('$baseUrl/verify/email', data: {
        "verification_code": verification_code,
      });
      if (response.statusCode == 200) {
        Get.snackbar("Success", "Email verified",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.primaryColor,
            colorText: Colors.white);
          Get.toNamed(Routes.BE_FIT);
        response.data['user']['is_verified'] = 1;
        await _storage.write(USER_KEY, response.data['user']);
        return true;
      } else {
        Get.snackbar("Error", "Failed to verify email",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to verify email",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return false;
    }

  }

  // Update Steps
  Future<void> updateSteps(int steps) async {
    try {
      final response = await _dio.post('$baseUrl/daily-logs/update-steps', data: {
        "steps_taken": steps,
      });

      if (response.statusCode == 200) {
        print("✅ Steps updated successfully!");
      } else {
        print("⚠️ Error updating steps: ${response.data}");
      }
    } catch (e) {
      print("❌ Dio error: $e");
    }
  }


// Add this helper method to ensure date format
  String _ensureMySQLDateFormat(String date) {
    // If already in YYYY-MM-DD format, return as is
    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(date)) {
      return date;
    }

    try {
      // Handle various input formats
      final parts = date.split(RegExp(r'[/-]'));
      if (parts.length != 3) return date;

      // If year is last (DD/MM/YYYY)
      if (parts[2].length == 4) {
        return "${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}";
      }
      // If year is first (YYYY/MM/DD)
      else if (parts[0].length == 4) {
        return "${parts[0]}-${parts[1].padLeft(2, '0')}-${parts[2].padLeft(2, '0')}";
      }

      return date;
    } catch (e) {
      return date;
    }
  }

  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post('$baseUrl/login', data: {
        'email': email,
        'password': password,
      });
      print(response);
      // Save token and user data
      await _storage.write(TOKEN_KEY, response.data['token']);
      await _storage.write(USER_KEY, response.data['user']);

      return User.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Logout
  Future<void> logout() async {
    await _storage.remove(TOKEN_KEY);
    await _storage.remove(USER_KEY);
  }

  // Goals
  Future<Map<String, dynamic>> saveGoals({
    required List<String> selectedGoals,
    required double targetWeight,
  }) async {
    try {
      final response = await _dio.post('$baseUrl/goals', data: {
        'selected_goals': selectedGoals,
        'target_weight': targetWeight,
      });

      // Update stored user data with new goals
      final userData = _storage.read(USER_KEY);
      if (userData != null) {
        userData['goals'] = response.data['goals'];
        await _storage.write(USER_KEY, userData);
      }

      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Weekly Review
  Future<WeeklyReview> getWeeklyReview() async {
    print('$baseUrl/weekly-review');
    try {
      final response = await _dio.get('$baseUrl/weekly-review');
      print(response);
      return WeeklyReview.fromJson(response.data);
    } on DioException catch (e) {
      print(e.response);
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    if (error.response?.data != null && error.response?.data['message'] != null) {
      return error.response?.data['message'];
    }
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';
      case DioExceptionType.sendTimeout:
        return 'Send timeout';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout';
      case DioExceptionType.badResponse:
        if (error.response?.statusCode == 401) {
          // Handle unauthorized access
          logout();
          return 'Session expired. Please login again.';
        }
        return 'Bad response';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      default:
        return 'Something went wrong';
    }
  }
}

