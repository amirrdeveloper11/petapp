import 'package:flutter/material.dart';
import 'package:front/features/auth/login/provider/login_provider.dart';
import 'package:front/widgets/custom_button.dart';
import 'package:provider/provider.dart';

/// Delegates to the shared [CustomButton] instead of duplicating its own
/// [ElevatedButton] styling, so login/register/checkout/booking all share
/// exactly the same button look.
class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context);

    return CustomButton(
      text: 'Login',
      isLoading: provider.isLoading,
      onPressed: provider.isLoading
          ? null
          : () => provider.submitLogin(context),
    );
  }
}
