class User {
  final String id;
  final String name;
  final String mobileNumber;
  final String email;
  final bool isActive;
  final String adharFront;
  final String adharBack;
  final String panFront;

  User({
    required this.id,
    required this.name,
    required this.mobileNumber,
    required this.email,
    required this.isActive,
    required this.adharFront,
    required this.adharBack,
    required this.panFront,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      mobileNumber: json['mobileNumber'],
      email: json['email'],
      isActive: json['isActive'],
      adharFront: json['adharFront'],
      adharBack: json['adharBack'],
      panFront: json['panFront'],
    );
  }
}
