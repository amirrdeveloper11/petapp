import 'package:flutter/material.dart';
import 'package:front/features/home/home_screen.dart';
import 'package:front/features/auth/login/login_page.dart';
import 'package:front/features/profile/profile_section.dart';
import 'package:front/features/auth/register/register_page.dart';
import 'package:front/features/auth/splash/splash_screen.dart';
import 'package:front/features/store/store_section.dart';
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

      // Section routes
      case AppRoutes.storeSection:
        return MaterialPageRoute(builder: (_) => const StoreSection());
      case AppRoutes.profileSection:
        return MaterialPageRoute(builder: (_) => const ProfileSection());
      case AppRoutes.vetSection:
        return MaterialPageRoute(builder: (_) => const VetSection());
        

      default:
        return MaterialPageRoute(builder: (_) => const Text("Page Not found"));
    }
  }
}
