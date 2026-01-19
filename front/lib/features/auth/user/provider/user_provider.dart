import 'package:flutter/material.dart';
import 'package:front/core/services/auth_service.dart';
import '../model/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  Future<void> updateProfile({required String name, required String email, String? password}) async {
    if (_user == null) return;

    final result = await AuthServiceDio.updateProfile(name: name, email: email, password: password);

    if (result['statusCode'] == 200) {
      final updatedUser = await AuthServiceDio.readStoredUser();
      if (updatedUser != null) {
        _user = updatedUser;
        notifyListeners();
      }
    }
  }

  Future<void> logout() async {
    _user = null;
    notifyListeners();
    await AuthServiceDio.logout();
  }

  Future<void> deleteAccount() async {
    _user = null;
    notifyListeners();
    await AuthServiceDio.deleteAccount();
  }
}
