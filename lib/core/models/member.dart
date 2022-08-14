import 'dart:convert';

class Member {
  String name;
  String email;
  Member({
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }

  factory Member.fromLocal(Map<String, dynamic> map) {
    return Member(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }

  factory Member.fromServer(Map<String, dynamic> map) {
    return Member(
      name: map['user_display_name'] ?? '',
      email: map['user_email'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Member.fromJson(String source) =>
      Member.fromLocal(json.decode(source));
}
