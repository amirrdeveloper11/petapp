import 'package:flutter/material.dart';
import 'package:front/features/auth/splash/widgets/splash_logo.dart';
import 'package:provider/provider.dart';
import 'package:front/features/auth/splash/provider/splash_provider.dart';
import 'package:front/core/theme.dart';
import 'package:front/widgets/custom_button.dart';

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
      backgroundColor: AppColors.cream,
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
          key: const ValueKey('loading'),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.tealSoft,
                borderRadius: BorderRadius.circular(AppRadii.xl),
                border: Border.all(color: AppColors.hairline),
              ),
              child: const Icon(
                Icons.pets_rounded,
                size: 46,
                color: AppColors.deepTeal,
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Pawpal',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 34,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Your Pet's Best Friend",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 40),
            const LoadingDots(),
          ],
        );

      case SplashState.error:
        return Padding(
          key: const ValueKey('error'),
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColors.dangerSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud_off_rounded,
                  size: 38,
                  color: AppColors.danger,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Server Unavailable',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please check your internet connection and try again',
                style: TextStyle(
                  color: AppColors.textSecondary.withOpacity(0.95),
                  fontSize: 14,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 200,
                child: CustomButton(
                  text: 'Try Again',
                  onPressed: () => provider.retry(context),
                  icon: Icons.refresh_rounded,
                ),
              ),
            ],
          ),
        );

      case SplashState.done:
        return const SizedBox.shrink(key: ValueKey('done'));
    }
  }
}
