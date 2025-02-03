part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const HOMEPAGE = _Paths.HOMEPAGE;
  static const PERSONAL_DETAILS = _Paths.PERSONAL_DETAILS;
  static const GOALS = _Paths.GOALS;
  static const BE_FIT = _Paths.BE_FIT;
  static const LOGIN = _Paths.LOGIN;
}

abstract class _Paths {

  static const HOMEPAGE = '/home-page';
  static const PERSONAL_DETAILS = '/personal-details';
  static const GOALS = '/goals';
  static const BE_FIT = '/be-fit';
  static const LOGIN = '/login';
}