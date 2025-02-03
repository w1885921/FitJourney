import 'package:fitness_project/app/modules/goals/controllers/goals_controller.dart';
import 'package:get/get.dart';

class GoalsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      GoalsController(),
      permanent: false,
    );
  }
}