import 'package:fitness_project/app/modules/be-fit/bindings/be_fit_binding.dart';
import 'package:fitness_project/app/modules/be-fit/views/be_fit_view.dart';
import 'package:fitness_project/app/modules/goals/bindings/goals_binding.dart';
import 'package:fitness_project/app/modules/goals/views/goals_view.dart';
import 'package:fitness_project/app/modules/home/bindings/home_binding.dart';
import 'package:fitness_project/app/modules/home/views/home_view.dart';
import 'package:fitness_project/app/modules/login/bindings/login_binding.dart';
import 'package:fitness_project/app/modules/login/views/login_view.dart';
import 'package:fitness_project/app/modules/personal-details/bindings/personal_details_binding.dart';
import 'package:fitness_project/app/modules/personal-details/views/personal_details_view.dart';
import 'package:fitness_project/app/modules/verification-code/views/verification_code.dart';
import 'package:get/get.dart';

import '../../middleware/auth_middleware.dart';
import '../modules/verification-code/bindings/verification_code_binding.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOMEPAGE;
  static final routes = [

    GetPage(
      name: _Paths.HOMEPAGE,
      page: () => HomePageView(),
      binding: HomePageBinding(),

    ),
    GetPage(
      name: _Paths.PERSONAL_DETAILS,
      page: () => PersonalDetailsView(),
      binding: PersonalDetailsBinding(),
    ),
    GetPage(
      name: _Paths.VERIFICATION_CODE,
      page: () => VerificationCodeView(),
      binding: VerificationCodeBinding(),
    ),
    GetPage(
      name: _Paths.GOALS,
      page: () => GoalsView(),
      binding: GoalsBinding(),
      middlewares: [AuthMiddleware()],

    ),
    GetPage(
      name: _Paths.BE_FIT,
      page: () => BeFitView(),
      binding: BeFitBinding(),
      middlewares: [AuthMiddleware()],

    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),

    ),
  ];

}