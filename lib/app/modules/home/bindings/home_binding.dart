import 'package:fitness_project/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';

class HomePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      HomePageController(),
      permanent: true,
    );
  }
}