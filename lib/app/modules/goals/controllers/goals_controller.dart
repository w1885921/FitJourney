import 'package:fitness_project/app/api/api_calls.dart';
import 'package:get/get.dart';


class GoalsController extends GetxController {
  final ApiService _apiService = ApiService();

  // Observable variables
  final selectedGoals = <String>[].obs;
  final maxSelections = 3;
  final goalWeight = ''.obs;
  final weightUnit = 'kg'.obs;
  final isLoading = false.obs;

  // Error states
  final weightError = RxnString();
  final goalsError = RxnString();

  @override
  void onInit() {
    super.onInit();
    clearErrors();
  }

  // Check if a goal is selected
  bool isSelected(String goal) => selectedGoals.contains(goal);

  // Toggle goal selection
  void toggleGoal(String goal) {
    if (isSelected(goal)) {
      selectedGoals.remove(goal);
      goalsError.value = null;
    } else if (selectedGoals.length < maxSelections) {
      selectedGoals.add(goal);
      goalsError.value = null;
    } else {
      Get.snackbar(
        'Maximum Goals Reached',
        'You can select up to $maxSelections goals',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Clear error messages
  void clearErrors() {
    weightError.value = null;
    goalsError.value = null;
  }

  // Validate form before submission
  bool validateForm() {
    clearErrors();
    bool isValid = true;

    if (selectedGoals.isEmpty) {
      goalsError.value = 'Please select at least one goal';
      isValid = false;
    }

    if (goalWeight.value.isEmpty) {
      weightError.value = 'Please enter your target weight';
      isValid = false;
    } else {
      try {
        double weight = double.parse(goalWeight.value);
        if (weight <= 0) {
          weightError.value = 'Please enter a valid weight';
          isValid = false;
        }
      } catch (e) {
        weightError.value = 'Please enter a valid number';
        isValid = false;
      }
    }

    return isValid;
  }

  // Save goals and proceed
  Future<void> saveGoals() async {
    if (!validateForm()) {
      return;
    }

    try {
      isLoading.value = true;

      // Convert weight to double and handle unit conversion if needed
      double weight = double.parse(goalWeight.value);
      if (weightUnit.value == 'lbs') {
        // Convert lbs to kg if needed
        weight = weight * 0.453592;
      }

      await _apiService.saveGoals(
        selectedGoals: selectedGoals,
        targetWeight: weight,
      );

      // Clear form after successful save
      selectedGoals.clear();
      goalWeight.value = '';
      clearErrors();

      // Navigate to the main app screen
      Get.offAllNamed('/be-fit');

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save goals: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update weight unit
  void updateWeightUnit(String? unit) {
    if (unit != null) {
      weightUnit.value = unit;
      // Optionally convert the existing weight value
      if (goalWeight.value.isNotEmpty) {
        try {
          double weight = double.parse(goalWeight.value);
          if (unit == 'kg' && weightUnit.value == 'lbs') {
            goalWeight.value = (weight * 0.453592).toStringAsFixed(1);
          } else if (unit == 'lbs' && weightUnit.value == 'kg') {
            goalWeight.value = (weight * 2.20462).toStringAsFixed(1);
          }
        } catch (e) {
          // Handle invalid number
        }
      }
    }
  }
}