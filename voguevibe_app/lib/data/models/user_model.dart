class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String token;
  final String? profileImage;
  final String? address;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.token,
    this.profileImage,
    this.address,
  });

  // JSON Serialization
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

  // JSON Deserialization
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      token: json['token'] as String,
      profileImage: json['avatar'] as String? ?? json['profileImage'] as String?,
      address: json['address'] as String?,
    );
  }

  // Create from auth response (login/register)
  factory UserModel.fromAuthResponse(Map<String, dynamic> response) {
    final user = response['user'] as Map<String, dynamic>;
    final token = response['token'] as String;

    return UserModel(
      id: user['id'].toString(),
      name: user['name'] as String,
      email: user['email'] as String,
      phone: user['phone'] as String?,
      token: token,
      profileImage: user['avatar'] as String?,
      address: user['address'] as String?,
    );
  }

  // Copy with method
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? token,
    String? profileImage,
    String? address,
  }) {
    return UserModel(
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
