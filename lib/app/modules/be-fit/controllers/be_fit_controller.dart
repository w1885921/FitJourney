import 'dart:async';
import 'package:fitness_project/app/api/api_calls.dart';
import 'package:fitness_project/app/routes/app_pages.dart';
import 'package:fitness_project/app/services/step_counter_service.dart';
import 'package:get/get.dart';
import 'package:fitness_project/app/models/models.dart';

class BeFitController extends GetxController {
  final ApiService _apiService = ApiService();
  final StepCounterService _stepCounterService = StepCounterService();

  final selectedIndex = 0.obs;
  final weeklyReview = Rxn<WeeklyReview>();
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