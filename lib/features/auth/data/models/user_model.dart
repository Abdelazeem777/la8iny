import 'dart:convert';

class User {
  final String id;
  final String fullname;
  final String email;
  final bool isOnline;
  final DateTime lastSeen;

  User({
    required this.id,
    required this.fullname,
    required this.email,
    this.isOnline = false,
    DateTime? lastSeen,
  }) : lastSeen = lastSeen ?? DateTime.now();

  User copyWith({
    String? id,
    String? fullname,
    String? email,
    bool? isOnline,
    DateTime? lastSeen,
  }) {
    return User(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      email: email ?? this.email,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullname': fullname,
      'email': email,
      'isOnline': isOnline,
      'lastSeen': lastSeen.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      fullname: map['fullname'] ?? '',
      email: map['email'] ?? '',
      isOnline: map['isOnline'] ?? false,
      lastSeen:
          map['lastSeen'] != null ? DateTime.parse(map['lastSeen']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, fullname: $fullname, email: $email, isOnline: $isOnline, lastSeen: $lastSeen)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.fullname == fullname &&
        other.email == email &&
        other.isOnline == isOnline &&
        other.lastSeen == lastSeen;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fullname.hashCode ^
        email.hashCode ^
        isOnline.hashCode ^
        lastSeen.hashCode;
  }
}
