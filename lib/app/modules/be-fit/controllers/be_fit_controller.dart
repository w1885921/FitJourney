import 'dart:async';
import 'package:fitness_project/app/api/api_calls.dart';
import 'package:fitness_project/app/routes/app_pages.dart';
import 'package:fitness_project/app/services/step_counter_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitness_project/app/models/models.dart';

class BeFitController extends GetxController {
  final ApiService _apiService = ApiService();
  final StepCounterService _stepCounterService = StepCounterService();

  final selectedIndex = 0.obs;
  final weeklyReview = Rxn<WeeklyReview>();
  final calories = Rxn<int>();
  final steps = Rxn<int>();

  final isLoading = false.obs;
  final currentUser = Rxn<User>();
  final todaySteps = 0.obs;
  final weeklySteps = <String, int>{}.obs;

  Timer? _stepUpdateTimer;

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
  }

  @override
  void onClose() {
    _stepUpdateTimer?.cancel();
    super.onClose();
  }

  Future<void> _initializeServices() async {
    await _stepCounterService.initializeStepCounter();
    await fetchUserData();
    await fetchWeeklyReview();
    _startStepTracking();
  }

  Future<void> updateCalories(int calories) async {
    try {
      isLoading.value = true;
      await _apiService.updateCalories(calories);
      Get.snackbar("Success", "Calories updated successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Failed to update calories!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateSteps(int steps) async {
    try {
      isLoading.value = true;
      await _apiService.updateSteps(steps);
      Get.snackbar("Success", "Steps updated successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Failed to update steps!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }



  void _startStepTracking() {
    // Update steps every second
    _stepUpdateTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
      todaySteps.value = await _stepCounterService.getTodaySteps();
      weeklySteps.value = await _stepCounterService.getWeeklySteps();
    });
  }

  Future<void> fetchUserData() async {
    try {
      isLoading.value = true;
      currentUser.value = _apiService.currentUser;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchWeeklyReview() async {
    try {
      isLoading.value = true;
      weeklyReview.value = await _apiService.getWeeklyReview();
      print(weeklyReview.value.toString());
    } catch (e) {
      Get.snackbar('Error', e.toString());
      Get.offNamed('/goals');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.logout();
      Get.offAllNamed(Routes.HOMEPAGE);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}