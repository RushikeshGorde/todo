import 'package:ecommers/controllers/CartController.dart';
import 'package:get/get.dart';
import '../views/splash_screen.dart';
import '../views/login_screen.dart';
import '../views/dashboard_screen.dart';
import '../views/product_list_screen.dart';
import '../views/product_details_screen.dart';
import '../views/cart_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String productList = '/product-list';
  static const String productDetails = '/product-details';
  static const String cart = '/cart';

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: dashboard, page: () => DashboardScreen()),
    GetPage(name: cart, page: () => CartScreen()),
    GetPage(
    name: productDetails,
    page: () => ProductDetailsScreen(),
    binding: BindingsBuilder(() {
      Get.lazyPut(() => CartController());
    }),
  ),
  ];
}