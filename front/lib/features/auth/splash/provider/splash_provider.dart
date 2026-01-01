import 'package:flutter/material.dart';
import 'package:front/core/services/auth_service.dart';
import 'package:front/core/services/secure_storage_service.dart';
import 'package:front/features/auth/user/model/user_model.dart';
import 'package:front/features/auth/user/provider/user_provider.dart';
import 'package:front/routes/app_routes.dart';
import 'package:provider/provider.dart';

enum SplashState { loading, error, done }

class SplashProvider with ChangeNotifier {
  SplashState state = SplashState.loading;
  bool _busy = false;

  Future<void> startSplash(BuildContext context) async {
    if (_busy) return;
    _busy = true;

    state = SplashState.loading;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    final refreshToken = await SecureStorageService.readRefreshToken();

    if (refreshToken == null) {
      _goToLogin(context);
      _busy = false;
      return;
    }

    final res = await AuthServiceDio.refreshToken(refreshToken: refreshToken);

    if (res['statusCode'] == 200) {
      final data = res['body']['data'];
      if (data != null && data['user'] != null && context.mounted) {
        final user = UserModel.fromJson(data['user']);
        context.read<UserProvider>().setUser(user);
        state = SplashState.done;
        notifyListeners();
        Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
      } else {
        _goToLogin(context);
      }
    } else if (res['statusCode'] == 401) {
      _goToLogin(context);
    } else {
      state = SplashState.error;
      notifyListeners();
    }

    _busy = false;
  }

  void retry(BuildContext context) {
    startSplash(context);
  }

  void _goToLogin(BuildContext context) async {
    await SecureStorageService.deleteAll();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
    }
  }
}
