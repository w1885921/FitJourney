import 'package:fitness_project/app/modules/be-fit/controllers/be_fit_controller.dart';
import 'package:get/get.dart';

class BeFitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      BeFitController(),
      permanent: true,
    );
  }
}