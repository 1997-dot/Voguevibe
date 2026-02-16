import '../../domain/entities/user.dart';

class AuthUserModel extends User {
  const AuthUserModel({
    required super.id,
    required super.name,
    required super.email,
    super.phone,
    required super.token,
    super.profileImage,
    super.address,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'].toString(),
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      token: json['token'] as String,
      profileImage:
          json['avatar'] as String? ?? json['profileImage'] as String?,
      address: json['address'] as String?,
    );
  }

  factory AuthUserModel.fromAuthResponse(Map<String, dynamic> response) {
    final user = response['user'] as Map<String, dynamic>;
    final token = response['token'] as String;

    return AuthUserModel(
      id: user['id'].toString(),
      name: user['name'] as String,
      email: user['email'] as String,
      phone: user['phone'] as String?,
      token: token,
      profileImage: user['avatar'] as String?,
      address: user['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'token': token,
      'profileImage': profileImage,
      'address': address,
    };
  }

  AuthUserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? token,
    String? profileImage,
    String? address,
  }) {
    return AuthUserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      token: token ?? this.token,
      profileImage: profileImage ?? this.profileImage,
      address: address ?? this.address,
    );
  }
}
