
import 'package:fitness_project/app/api/api_calls.dart';
import 'package:fitness_project/app/routes/app_pages.dart';
import 'package:get/get.dart';


class PersonalDetailsController extends GetxController {
  final ApiService _apiService = ApiService();
  final fullName = ''.obs;
  final dateOfBirth = ''.obs;
  final email = ''.obs;
  final mobile = ''.obs;
  final nationality = ''.obs;
  final password = ''.obs;
  final isLoading = false.obs;
  final height = ''.obs;
  final weight = ''.obs;
  final gender = ''.obs;

  void updateFullName(String value) => fullName.value = value;
  void updateDateOfBirth(String value) => dateOfBirth.value = value;
  void updateEmail(String value) => email.value = value;
  void updateMobile(String value) => mobile.value = value;
  void updateNationality(String value) => nationality.value = value;
  @override
  void onInit() {
    super.onInit();
  }
  Future<void> register() async {
    if (fullName.value.isEmpty || email.value.isEmpty ||
        password.value.isEmpty || dateOfBirth.value.isEmpty ||
        mobile.value.isEmpty || height.value.isEmpty || weight.value.isEmpty || gender.value.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }

    try {
      isLoading.value = true;
      print("Debug - Weight: ${weight.value} (${weight.value.runtimeType})");
      print("Debug - Height: ${height.value} (${height.value.runtimeType})");
      await _apiService.register(
        fullName: fullName.value,
        email: email.value,
        password: password.value,
        dateOfBirth: dateOfBirth.value,
        mobileNumber: mobile.value,
        weight: weight.value != null ? double.tryParse(weight.value.toString()) : null,
        height: height.value != null ? double.tryParse(height.value.toString()) : null,
        gender: gender.value,
      );
      print("Debug - Height: ${height.value} (${height.value.runtimeType})");
      Get.toNamed(Routes.GOALS);
    } catch (e) {
      Get.snackbar('Error', e.toString());
      Get.snackbar('Errortttt', weight.value.toString());
      Get.snackbar('Errortttt', height.value.toString());
    } finally {
      isLoading.value = false;
    }
  }

}