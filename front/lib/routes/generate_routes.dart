import 'package:flutter/material.dart';

import 'package:front/features/auth/login/login_page.dart';
import 'package:front/features/auth/register/register_page.dart';
import 'package:front/features/auth/splash/splash_screen.dart';
import 'package:front/features/home/home_screen.dart';
import 'package:front/features/homepage/home_page_section.dart';
import 'package:front/features/homepage/models/product_model.dart';
import 'package:front/features/profile/profile_section.dart';
import 'package:front/features/store/pages/cart_page.dart';
import 'package:front/features/store/pages/product_details_page.dart';
import 'package:front/features/vet/vet_section.dart';
import 'package:front/routes/app_routes.dart';

class GenerateRoutes {
  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case AppRoutes.registerScreen:
        return MaterialPageRoute(builder: (_) => const RegisterPage());

      case AppRoutes.homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case AppRoutes.homePageSection:
        return MaterialPageRoute(
          builder: (_) => const HomePageSection(),
        );

      case AppRoutes.profileSection:
        return MaterialPageRoute(builder: (_) => const ProfileSection());

      case AppRoutes.vetSection:
        return MaterialPageRoute(builder: (_) => const VetSection());

      case AppRoutes.productDetails:
        final args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => ProductDetailsPage(
            product: args['product'] as ProductModel,
            categoryName: args['categoryName'] as String?,
          ),
        );

      case AppRoutes.cart:
        return MaterialPageRoute(builder: (_) => const CartPage());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page Not Found')),
          ),
        );
    }
  }
}