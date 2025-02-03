import 'package:fitness_project/app/modules/login/controllers/login_controller.dart';
import 'package:get/get.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      LoginController(),
      permanent: false,
    );
  }
}