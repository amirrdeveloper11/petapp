import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:front/core/services/auth_service.dart';
import 'package:front/features/auth/user/provider/user_provider.dart';
import 'package:front/features/auth/user/model/user_model.dart';
import 'package:front/routes/app_routes.dart';

class LoginProvider with ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isLoading = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  Future<void> submitLogin(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    isLoading = true;
    notifyListeners();

    try {
      final result = await AuthServiceDio.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final status = result['statusCode'] as int;
      final body = result['body'];

      if (status == 200) {
        final userMap = (body['data']?['user'] ?? body['data']) as Map<String, dynamic>?;
        if (userMap != null) {
          final user = UserModel.fromJson(userMap);
          Provider.of<UserProvider>(context, listen: false).setUser(user);
        } else {
          // try read stored
          final stored = await AuthServiceDio.readStoredUser();
          if (stored != null) {
            Provider.of<UserProvider>(context, listen: false).setUser(stored);
          }
        }

        if (!context.mounted) return;
        Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
      } else {
        // print the error details
        debugPrint('[LOGIN] Non-200 response: $body');
        // optionally show a snackbar
        if (context.mounted) {
          final message = (body['message'] ?? 'Login failed').toString();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        }
      }
    } catch (e, st) {
      debugPrint('[LOGIN] exception: $e');
      debugPrint('$st');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('An error occurred')));
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void goToRegister(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.registerScreen);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
