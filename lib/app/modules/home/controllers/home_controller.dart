
import 'package:fitness_project/app/api/api_calls.dart';
import 'package:fitness_project/app/routes/app_pages.dart';
import 'package:get/get.dart';


class HomePageController extends GetxController {
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  void checkAuthStatus() async {
    await Future.delayed(Duration(milliseconds: 200));
    if (_apiService.isLoggedIn) {
      Get.offAllNamed(Routes.BE_FIT);
    }
  }
}