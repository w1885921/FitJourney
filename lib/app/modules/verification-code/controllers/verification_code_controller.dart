import 'dart:async';
import 'package:fitness_project/app/api/api_calls.dart';
import 'package:fitness_project/app/routes/app_pages.dart';
import 'package:fitness_project/app/services/step_counter_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitness_project/app/models/models.dart';

class VerificationCodeController extends GetxController {
  final ApiService _apiService = ApiService();
  final StepCounterService _stepCounterService = StepCounterService();


  final isLoading = false.obs;
  final currentUser = Rxn<User>();
  final todaySteps = 0.obs;

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

  Future<void> logout() async {
    try {
      await _apiService.logout();
      Get.offAllNamed(Routes.HOMEPAGE);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<bool> sendVerificationEmail(String code) async {
    final user = _apiService.currentUser;

    if (user != null && user.isVerified == 0 ) {
      return await _apiService.sendEmailVerification(code);
    }

    return false;
  }

  Future<void> resendCode() async {
    await _apiService.resendCode();
  }
}