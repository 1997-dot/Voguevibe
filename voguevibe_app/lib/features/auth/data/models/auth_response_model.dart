import 'user_model.dart';

class AuthResponseModel {
  final AuthUserModel user;
  final String token;

  const AuthResponseModel({
    required this.user,
    required this.token,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      user: AuthUserModel.fromAuthResponse(json),
      token: json['token'] as String,
    );
  }
}
