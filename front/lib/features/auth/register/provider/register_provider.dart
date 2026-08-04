import 'package:flutter/material.dart';
import 'package:front/core/services/auth_service.dart';
import 'package:front/features/auth/user/provider/user_provider.dart';
import 'package:front/features/auth/user/model/user_model.dart';
import 'package:front/routes/app_routes.dart';
import 'package:provider/provider.dart';

class RegisterProvider with ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isLoading = false;

  bool get hasMinLength => passwordController.text.length >= 6;
  bool get hasNumber => RegExp(r'\d').hasMatch(passwordController.text);
  bool get hasSpecial =>
      RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(passwordController.text);
  bool get passwordsMatch =>
      passwordController.text == confirmPasswordController.text &&
      confirmPasswordController.text.isNotEmpty;

  bool get isPasswordValid =>
      hasMinLength && hasNumber && hasSpecial && passwordsMatch;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    notifyListeners();
  }

  Future<void> submitRegister(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    if (!isPasswordValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password requirements not met')),
      );
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final result = await AuthServiceDio.register(
        name: fullNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        passwordConfirmation: confirmPasswordController.text,
      );

      final status = result['statusCode'];
      final body = result['body'];

      if (status == 200 || status == 201) {
        final userMap =
            (body['data']?['user'] ?? body['data']) as Map<String, dynamic>?;

        if (userMap != null) {
          final user = UserModel.fromJson(userMap);
          Provider.of<UserProvider>(context, listen: false).setUser(user);
        }

        if (!context.mounted) return;
        Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(body['message'] ?? 'Registration failed')),
        );
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
