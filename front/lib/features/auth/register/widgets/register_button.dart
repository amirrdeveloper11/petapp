import 'package:flutter/material.dart';
import 'package:front/features/auth/register/provider/register_provider.dart';
import 'package:front/widgets/custom_button.dart';
import 'package:provider/provider.dart';

/// Delegates to the shared [CustomButton] instead of duplicating its own
/// [ElevatedButton] styling, so login/register/checkout/booking all share
/// exactly the same button look.
class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegisterProvider>(context);

    return CustomButton(
      text: 'Register',
      isLoading: provider.isLoading,
      onPressed: provider.isLoading
          ? null
          : () => provider.submitRegister(context),
    );
  }
}
