class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String token;
  final String? profileImage;
  final String? address;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.token,
    this.profileImage,
    this.address,
  });
}
