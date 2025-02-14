import 'dart:convert';

class User {
  final String id;
  final String fullname;
  final String email;
  User({
    required this.id,
    required this.fullname,
    required this.email,
  });

  User copyWith({
    String? id,
    String? fullname,
    String? email,
  }) {
    return User(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullname': fullname,
      'email': email,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      fullname: map['fullname'] ?? '',
      email: map['email'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() => 'User(id: $id, fullname: $fullname, email: $email)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.fullname == fullname &&
        other.email == email;
  }

  @override
  int get hashCode => id.hashCode ^ fullname.hashCode ^ email.hashCode;
}
