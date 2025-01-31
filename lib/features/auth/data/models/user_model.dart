import 'dart:convert';

class User {
  final String fullname;
  final String email;
  User({
    required this.fullname,
    required this.email,
  });

  User copyWith({
    String? fullname,
    String? email,
  }) {
    return User(
      fullname: fullname ?? this.fullname,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullname': fullname,
      'email': email,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      fullname: map['fullname'] ?? '',
      email: map['email'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() => 'User(fullname: $fullname, email: $email)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User && other.fullname == fullname && other.email == email;
  }

  @override
  int get hashCode => fullname.hashCode ^ email.hashCode;
}
