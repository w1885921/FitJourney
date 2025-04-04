import 'package:fitness_project/app/modules/verification-code/controllers/verification_code_controller.dart';
import 'package:get/get.dart';

class VerificationCodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      VerificationCodeController(),
      permanent: true,
    );
  }
}