import 'package:get/get.dart';
import '../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    navigateToLogin();
    super.onInit();
  }

  void navigateToLogin() async {
    await Future.delayed(Duration(seconds: 3));
    Get.offAllNamed(AppRoutes.login);
  }
}
