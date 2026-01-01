import 'package:flutter/material.dart';
import 'package:front/features/auth/login/provider/login_provider.dart';
import 'package:front/features/auth/splash/provider/splash_provider.dart';
import 'package:front/features/auth/user/provider/user_provider.dart';
import 'package:front/features/petcrud/provider/pet_provider.dart';
import 'package:front/routes/app_routes.dart';
import 'package:front/routes/generate_routes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PetProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wanis',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ar')],
      onGenerateRoute: GenerateRoutes.generatedRoute,
      initialRoute: AppRoutes.splashScreen,
    );
  }
}
