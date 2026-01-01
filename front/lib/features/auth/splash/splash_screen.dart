import 'package:flutter/material.dart';
import 'package:front/features/auth/splash/widgets/splash_logo.dart';
import 'package:provider/provider.dart';
import 'package:front/features/auth/splash/provider/splash_provider.dart';
import 'package:front/core/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<SplashProvider>().startSplash(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SplashProvider>();

    return Scaffold(
      backgroundColor: AppColors.primaryGreenLight,
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildChild(provider),
        ),
      ),
    );
  }

  Widget _buildChild(SplashProvider provider) {
    switch (provider.state) {
      case SplashState.loading:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.pets, size: 90, color: AppColors.primaryGreen),
            SizedBox(height: 25),
            Text(
              "Wanis",
              style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 34,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Your Pet’s Best Friend",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 40),
            LoadingDots(),
          ],
        );

      case SplashState.error:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 70, color: Colors.red),
            const SizedBox(height: 20),
            const Text(
              "Server Unavailable",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Please check your internet connection and try again",
              style: TextStyle(color: Colors.black54, fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => provider.retry(context),
              child:
                  const Text("Try Again", style: TextStyle(fontSize: 18)),
            ),
          ],
        );

      case SplashState.done:
        return const SizedBox.shrink();
    }
  }
}
