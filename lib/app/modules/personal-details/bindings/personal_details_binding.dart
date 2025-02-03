import 'package:fitness_project/app/modules/personal-details/controllers/personal_details_controller.dart';
import 'package:get/get.dart';

class PersonalDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      PersonalDetailsController(),
      permanent: false,
    );
  }
}