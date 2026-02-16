import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/result.dart';
import '../models/user_model.dart';

class AuthLocalSource {
  static const String _userKey = 'saved_user';
  static const String _tokenKey = 'auth_token';

  Future<Result<void>> saveUser(AuthUserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = json.encode(user.toJson());
      await prefs.setString(_userKey, userJson);
      await prefs.setString(_tokenKey, user.token);
      return const Success(null);
    } catch (e) {
      return Failure('Failed to save user data: ${e.toString()}');
    }
  }

  Future<Result<AuthUserModel?>> getSavedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);

      if (userJson != null) {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        return Success(AuthUserModel.fromJson(userMap));
      }
      return const Success(null);
    } catch (e) {
      return const Success(null);
    }
  }

  Future<Result<String?>> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return Success(prefs.getString(_tokenKey));
    } catch (e) {
      return const Success(null);
    }
  }

  Future<Result<void>> clearUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.remove(_tokenKey);
      return const Success(null);
    } catch (e) {
      return Failure('Failed to logout: ${e.toString()}');
    }
  }
}
